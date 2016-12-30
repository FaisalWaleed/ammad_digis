class Pharmacist::PrescriptionsController < Pharmacist::BaseController
  
  before_action :check_for_pharmacies
  
  def index
    @dispense_orders = current_pharmacy.dispense_orders.relevant.order('dispense_orders.created_at DESC')
    
    render(:partial => 'index', :collection => @dispense_orders, :as => :order) if request.xhr?
  end
  
  def archived
    @dispense_orders = current_pharmacy.dispense_orders.delivered.order('dispense_orders.created_at DESC')
  end
  
  def partials
    @dispense_orders = current_pharmacy.dispense_orders.ongoing.order('dispense_orders.created_at DESC')
  end

  def show
    @dispense_order = current_pharmacy.dispense_orders.find(params[:id])
    
    uri = URI.parse(request.referer)
    @fillable = uri.path == "/pharmacist/prescriptions/partials"
    
    if params.has_key?(:print)
      render layout: 'prescription-print'
    else
      render partial: 'partials/modals/pharmacist/pharm_modal'
    end
  end
  
  def ask_question
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])
    render partial: 'partials/modals/pharmacist/question'
  end
  
  def transfer
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])
    
    unless request.post?
      @transfer = current_pharmacy.dispense_orders.build( dispense_order_params )
    else
      current_pharmacy.prescription_transfers.create(dispense_order_params)
      
      @dispense_order.consignments.where('consignments.dispensable_id IN (?)', dispense_order_params[:dispensable_ids]).destroy_all
      
      if @dispense_order.dispensables.count.zero?
        @dispense_order.destroy
      end

      flash[:notice] = "Transfer was successful"
    end
    
    render partial: 'partials/modals/pharmacist/pharm_modal'
  end
  
  def import
    @prescription = Prescription.find_by(verification_params)
    
    if @prescription
      if @prescription.transfer_to(current_pharmacy)
        flash[:notice] = "Import successful"
      else
        flash[:error] = "Import failed: The specified prescription has already been filled"
      end
    else
      flash[:error] = "Import failed: No matching prescription found"
    end
    
    render :nothing => true
#     redirect_to pharmacist_prescriptions_path
  end
  
  def messages
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])

    unless request.post?
      render partial: 'partials/modals/pharmacist/message'
    else
      if @message = current_pharmacist.messages.create(message_params.merge(
            asset_id: @dispense_order.id,
            asset_type: 'DispenseOrder'
        ))
        
        @physician = @message.asset.physician
        
        begin
          if @physician.preferences.notification_methods.include?(:email)
            PhysicianMailer.prescription_message(@physician, @message).deliver_now
          end
          
          if @physician.preferences.notification_methods.include?(:sms)
            c = Twilio::REST::Client.new
            
            from = ENV["TWILIO_NUMBER"]
            to = "+1" + @physician.phone_primary
            
            c.messages.create from: from, to: to, body: @message.body
          end
        rescue
          # TODO: notify sender
        end
      end
      flash[:notice] = "Message sent"
    end
    
    render partial: 'partials/modals/pharmacist/pharm_modal'
  end
  
  def processing
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])
    
    if @dispense_order
      if dispense_order_params[:dispensable_ids].present?
        current_pharmacy.dispense_orders.create(dispense_order_params).processing!
        
        @dispense_order.consignments.where('consignments.dispensable_id IN (?)', dispense_order_params[:dispensable_ids]).destroy_all
        
        if @dispense_order.dispensables.count.zero?
          @dispense_order.destroy
        else
          @dispense_order.update_attribute :transferred_at, Time.now
        end
      else
        @dispense_order.processing!
      end
      
      render nothing: true
    else
      render nothing: true
    end
  end
  
  def ready
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])
    
    if @dispense_order
      processable_attributes = prescription_params[:dispensables_attributes].select{ |k,v| v[:process] == '1' }
      processable_ids = processable_attributes.values.collect{ |v| v['id'] }.compact
      
      processable_params = {
        :prescription_id => @dispense_order.prescription.id,
        :dispensable_ids => processable_ids,
        }

      if current_pharmacy.dispense_orders.create(processable_params).ready!({dispensables_attributes: processable_attributes.values})
        removable_ids = prescription_params[:dispensables_attributes].select{ |k,v| v[:fully_filled] == '1' }.values.collect{ |v| v['id'] }.compact
        
        @dispense_order.consignments.where('consignments.dispensable_id IN (?)', processable_ids).destroy_all
        
        if @dispense_order.dispensables.count.zero?
          @dispense_order.destroy
        end
      end
      
      render nothing: true
    else
      render nothing: true
    end
  end
  
  def delivered
    @dispense_order = current_pharmacy.dispense_orders.find(params[:prescription_id])
    
    if @dispense_order
      @dispense_order.delivered!
      
      render nothing: true
    else
      render nothing: true
    end
  end
  
  private
  
  def prescription_params
    params.require(:prescription).permit(
      :dispensables_attributes => [
                                   :id,
                                   :drug_filled,
                                   :strength_filled,
                                   :dose_filled,
                                   :process,
                                   :fully_filled,
                                   :disbursements_attributes => [
                                                                  :annotation,
                                                                  :pharmacist_id,
                                                                  :pharmacy_id
                                                                 ]
                                   ]
      )
  end
  
  def dispense_order_params
    params.require(:dispense_order).permit(
      :pharmacy_id,
      :prescription_id,
      :dispensable_ids => [],
      :messages_attributes => [ :subject, :body, :asset_type, :asset_id ]
      )
  end
  
  def message_params
    params.require(:message).permit(
      :subject, :body, :mark_as_resolved, :require_response
      )
  end
  
  def verification_params
    params.require(:dispense_order).permit(
      :verification_pin,
      :identifier
    )
  end
end

class Physician::MessagesController < Physician::BaseController
  after_action :mark_as_read, :only => [ :create ]
  
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @status = params[:status]
    @term = params[:term]
    @start_date = params[:start_date].to_date rescue nil
    @end_date = params[:end_date].to_date rescue nil

    if @status == 'resolved'
      dispense_orders = DispenseOrder.resolved_for_dr(current_physician)
      diagnostics = Diagnostic.resolved_for_dr(current_physician)
    else
      dispense_orders = DispenseOrder.waiting_on_dr(current_physician)
      diagnostics = Diagnostic.waiting_on_dr(current_physician)
    end
    
    if @term.present?
      dispense_orders = dispense_orders.where('dispense_orders.identifier = ? OR messages.body ILIKE ?', "#{@term}", "%#{@term}%")
      diagnostics = diagnostics.where('diagnostics.identifier = ? OR messages.body ILIKE ?', "#{@term}", "%#{@term}%")
    end
    
    @conversations = (dispense_orders + diagnostics).sort{ |a,b| b.messages.sort{ |a,b| b.updated_at <=> a.updated_at }.first.updated_at <=> a.messages.sort{ |a,b| b.updated_at <=> a.updated_at }.first.updated_at }
    
    @conversations = Kaminari.paginate_array(@conversations).page(@page).per(@per_page)
  end
  
  def show
    if params[:type] == 'diagnostic'
      @conversation = Diagnostic.find(params[:id])
      render partial: 'partials/modals/physician/diagnostics/message'
    else
      @conversation = DispenseOrder.find(params[:id])
      render partial: 'partials/modals/physician/prescriptions/message'
    end
  end

  def create
    @message = current_physician.messages.create(message_params)
    
    flash[:notice] = "Message sent"
    
    if @message.asset_type == 'DispenseOrder'
      @conversation = @message.asset
      
      render partial: 'partials/modals/physician/prescriptions/message'
    else
      @conversation = @message.asset
      
      render partial: 'partials/modals/physician/diagnostics/message'
    end
  end

  private
  
  def mark_as_read
    @conversation.messages.where('messages.id != ?', @message.id).map(&:mark_as_read!) rescue nil
  end

  def message_params
    params.require(:message).permit(
      :require_response,
      :mark_as_resolved,
      :body,
      :asset_type,
      :asset_id
      )
  end
end

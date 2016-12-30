class Technician::DiagnosticsController < Technician::BaseController
  before_action :check_for_laboratories
  
  def index
    @diagnostics = current_laboratory.diagnostics.open.order('diagnostics.created_at DESC')
  end
  
  def index_closed
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @term = params[:term]

    @diagnostics = current_laboratory.diagnostics.closed.order('diagnostics.created_at DESC')
    
    if @term
      @diagnostics = @diagnostics.joins(:patient).where('patients.firstname ILIKE ? OR patients.lastname ILIKE ? OR diagnostics.identifier = ?', "#{@term}%", "#{@term}%", "#{@term}")
    end
    
    @diagnostics = @diagnostics.page(@page).per(@per_page)
  end

  def show
    @diagnostic = current_laboratory.diagnostics.find(params[:id])
    @tags = TestTag.with_diagnostic(@diagnostic)
    @profiles = @diagnostic.profiled_testings.group_by(&:test_profile)
    
    unless @diagnostic.commentable?
      @diagnostic.messages.map(&:mark_as_read!)
    end
    
    render partial: 'partials/modals/technician/tech_modal'
  end

  def update
  end
  
  def upload
    @diagnostic = current_laboratory.diagnostics.find(params[:id])
    
    if params[:diagnostic].present?
      if @diagnostic.update_attributes(diagnostic_params.merge({
                                                                reviewed: false,
                                                                last_modifier_type: current_technician.class.name,
                                                                last_modifier_id: current_technician.id
                                                               }))
#         @diagnostic.mark_as_unreviewed! # do this in one step above
      else
        
      end
    end
    
    render partial: 'partials/modals/technician/upload'
  end
  
  def ask_question
    @diagnostic = current_laboratory.diagnostics.find(params[:diagnostic_id])
    render partial: 'partials/modals/technician/question'
  end
  
  def import
    @diagnostic = Diagnostic.find_by(verification_params)
    
    if @diagnostic
      if @diagnostic.transfer_to(current_laboratory)
        flash[:notice] = "Import successful"
      else
        flash[:error] = "Import failed: The specified diagnostic has already been closed"
      end
    else
      flash[:error] = "Import failed: No matching diagnostic found"
    end
    
    render :nothing => true
#     redirect_to technician_diagnostics_path
  end
  
  def messages
    @diagnostic = current_laboratory.diagnostics.find(params[:diagnostic_id])
    @tags = TestTag.with_diagnostic(@diagnostic)
    @profiles = @diagnostic.profiled_testings.group_by(&:test_profile)
    
    unless request.post?
      render partial: 'partials/modals/technician/message'
    else
      if @message = current_technician.messages.create(message_params.merge(
                                                                            asset_id: @diagnostic.id,
                                                                            asset_type: 'Diagnostic'
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
    
    @tags = TestTag.with_diagnostic(@diagnostic).includes(:test_requests)
    render partial: 'partials/modals/technician/tech_modal'
  end
  
  private
  
  def message_params
    params.require(:message).permit(
      :subject, :body, :mark_as_resolved, :require_response
    )
  end
  
  def verification_params
    params.require(:diagnostic).permit(
      :verification_pin,
      :identifier
    )
  end
  
  def diagnostic_params
    params.require(:diagnostic).permit(
      :attachments_attributes => [
                                  :id,
                                  :_destroy,
                                  :file,
                                  :title,
                                  :description
                                 ]
      )
  end
end

class TestCenter::DiagnosticsController < TestCenter::BaseController

  def index
    @diagnostics = current_test_center.diagnostics.order('created_at DESC')
  end

  def show
    @diagnostic = current_test_center.diagnostics.find(params[:id])
    @tags = TestTag.with_diagnostic(@diagnostic)
    @profiles = @diagnostic.profiled_testings.group_by(&:test_profile)
    
    unless @diagnostic.commentable?
      @diagnostic.messages.map(&:mark_as_read!)
    end
    
    render partial: 'partials/modals/test_center/tech_modal'
  end

  def update
  end
  
  def upload
    @diagnostic = current_test_center.diagnostics.find(params[:id])
    
    if params[:diagnostic].present?
      if @diagnostic.update_attributes(diagnostic_params.merge({
                                                                reviewed: false,
                                                                last_modifier_type: current_test_center.class.name,
                                                                last_modifier_id: current_test_center.id
                                                               }))
#         @diagnostic.mark_as_unreviewed! # do this in one step above
      else
        
      end
    end
    
    render partial: 'partials/modals/test_center/upload'
  end
  
  def ask_question
    @diagnostic = current_test_center.diagnostics.find(params[:diagnostic_id])
    render partial: 'partials/modals/test_center/question'
  end
  
  def import
    @diagnostic = Diagnostic.find_by(verification_params)
    
    if @diagnostic
      if @diagnostic.transfer_to(current_test_center)
        flash[:notice] = "Import successful"
      else
        flash[:error] = "Import failed: The specified diagnostic has already been closed"
      end
    else
      flash[:error] = "Import failed: No matching diagnostic found"
    end
    
    render :nothing => true
#     redirect_to test_center_diagnostics_path
  end
  
  def messages
    @diagnostic = current_test_center.diagnostics.find(params[:diagnostic_id])
    
    unless request.post?
      render partial: 'partials/modals/test_center/message'
    else
      if @message = current_test_center.messages.create(message_params.merge(
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
    render partial: 'partials/modals/test_center/tech_modal'
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

class Technician::MessagesController < Technician::BaseController
  after_action :mark_as_read, :only => [ :create ]
  
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @status = params[:status]
    @term = params[:term]
    @start_date = params[:start_date].to_date rescue nil
    @end_date = params[:end_date].to_date rescue nil
    
    if @status == 'resolved'
      diagnostics = Diagnostic.resolved_for_technician(current_technician)
    else
      diagnostics = Diagnostic.waiting_on_technician(current_technician)
    end
    
    if @term.present?
      diagnostics = diagnostics.where('diagnostics.identifier = ? OR messages.body ILIKE ?', "#{@term}", "%#{@term}%")
    end
    
    @conversations = (diagnostics).sort{ |a,b| b.messages.sort{ |a,b| b.updated_at <=> a.updated_at }.first.updated_at <=> a.messages.sort{ |a,b| b.updated_at <=> a.updated_at }.first.updated_at }
    
    @conversations = Kaminari.paginate_array(@conversations).page(@page).per(@per_page)
  end
  
  def show
    @conversation = Diagnostic.find(params[:id])
    render partial: 'partials/modals/technician/messages/message'
  end
  
  def create
    @message = current_technician.messages.create(message_params)
    
    flash[:notice] = "Message sent"
    
    @conversation = @message.asset
    
    render partial: 'partials/modals/technician/messages/message'
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

class Technician::Auth::ActivationsController < Technician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  layout 'technician/session'

  skip_before_action :require_active_subscription
  
  def new
    @technician = Technician.find(params[:technician_id]) if params[:technician_id]
  end

  def create
    if params[:activation_code].blank?
      flash[:error] = "You must provide a valid activation URL"
    else
      @technician = Technician.find_using_perishable_token(params[:activation_code], 1.week)
      
      unless @technician.blank? || @technician.active?
        if @technician.activate!
          flash[:notice] = "Your account has been activated!"
          TechnicianSession.create(@technician, false) # Log technician in manually
          TechnicianMailer.activation_welcome(@technician).deliver_now
        end
      else
        flash[:error] = "That account does not exist or has already been activated"
      end
    end
    
    redirect_to technician_login_url
  end
  
  def resend
    if params[:technician_id]
      @technician = Technician.find params[:technician_id]
      if @technician && !@technician.active?
        TechnicianMailer.activation_instructions(@technician).deliver_now
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
      else
        flash[:error] = "Your account is already active!"
      end
    end
    
    redirect_to technician_login_url
  end
end

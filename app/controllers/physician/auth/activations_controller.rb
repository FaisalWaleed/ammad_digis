class Physician::Auth::ActivationsController < Physician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  layout 'physician/session'
  
  def new
    @physician = Physician.find(params[:physician_id]) if params[:physician_id]
  end

  def create
    if params[:activation_code].blank?
      flash[:error] = "You must provide a valid activation URL"
    else
      @physician = Physician.find_using_perishable_token(params[:activation_code], 1.week)
      
      unless @physician.blank? || @physician.active?
        if @physician.activate!
          flash[:notice] = "Your account has been activated!"
          PhysicianSession.create(@physician, false) # Log physician in manually
          PhysicianMailer.activation_welcome(@physician).deliver_now
        end
      else
        flash[:error] = "That account does not exist or has already been activated"
      end
    end
    
    redirect_to physician_login_url
  end
  
  def resend
    if params[:physician_id]
      @physician = Physician.find params[:physician_id]
      if @physician && !@physician.active?
        PhysicianMailer.activation_instructions(@physician).deliver_now
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
      else
        flash[:error] = "Your account is already active!"
      end
    end
    
    redirect_to physician_login_url
  end
end

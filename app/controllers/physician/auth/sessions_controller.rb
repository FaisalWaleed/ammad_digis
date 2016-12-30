class Physician::Auth::SessionsController < Physician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  skip_before_action :require_active_subscription
  
  layout 'physician/session'
  
  def new
    @physician_session = PhysicianSession.new
  end

  def create
    @physician_session = PhysicianSession.new(params[:physician_session])
    
    if @physician_session.save
      flash.now[:notice] = "Login successful"
      redirect_to physician_root_url
    else
      if @physician_session.attempted_record && !@physician_session.attempted_record.active?
        flash.now[:error] = "Your account has not yet ben activated"
        redirect_to physician_new_activation_url(:physician_id => @physician_session.attempted_record)
      else
        flash.now[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_physician_session.destroy
    flash.now[:notice] = "You have been logged out successfully"
    redirect_to physician_login_url
  end
end

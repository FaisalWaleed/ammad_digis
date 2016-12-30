class Technician::Auth::SessionsController < Technician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  skip_before_action :require_active_subscription
  
  layout 'technician/session'
  
  def new
    @technician_session = TechnicianSession.new
  end

  def create
    @technician_session = TechnicianSession.new(params[:technician_session])
    
    if @technician_session.save
      flash[:notice] = "Login successful"
      redirect_to technician_root_url
    else
      if @technician_session.attempted_record && !@technician_session.attempted_record.active?
        flash[:error] = "Your account has not yet been activated"
        redirect_to technician_new_activation_url(:technician_id => @technician_session.attempted_record)
      else
        flash[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_technician_session.destroy
    session[:current_laboratory] = nil
    flash[:notice] = "You have been logged out successfully"
    redirect_to technician_login_url
  end
end

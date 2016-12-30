class Pharmacy::Auth::SessionsController < Pharmacy::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  layout 'pharmacy/session'
  
  skip_before_action :require_active_subscription

  def new
    @pharmacy_session = PharmacySession.new
  end

  def create
    @pharmacy_session = PharmacySession.new(params[:pharmacy_session])
    
    if @pharmacy_session.save
      flash.now[:notice] = "Login successful"
      redirect_to pharmacy_root_url
    else
      if @pharmacy_session.attempted_record && !@pharmacy_session.attempted_record.active?
        flash.now[:error] = "Your account has not yet been activated"
        redirect_to pharmacy_new_activation_url(:pharmacy_id => @pharmacy_session.attempted_record)
      else
        flash.now[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_pharmacy_session.destroy
    session[:current_pharmacy] = nil
    flash.now[:notice] = "You have been logged out successfully"
    redirect_to pharmacy_login_url
  end
end

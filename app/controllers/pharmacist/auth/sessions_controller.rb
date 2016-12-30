class Pharmacist::Auth::SessionsController < Pharmacist::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  layout 'pharmacist/session'
  
  skip_before_action :require_active_subscription

  def new
    @pharmacist_session = PharmacistSession.new
  end

  def create
    @pharmacist_session = PharmacistSession.new(params[:pharmacist_session])
    
    if @pharmacist_session.save
      flash.now[:notice] = "Login successful"
      redirect_to pharmacist_root_url
    else
      if @pharmacist_session.attempted_record && !@pharmacist_session.attempted_record.active?
        flash.now[:error] = "Your account has not yet been activated"
        redirect_to pharmacist_new_activation_url(:pharmacist_id => @pharmacist_session.attempted_record)
      else
        flash.now[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_pharmacist_session.destroy
    session[:current_pharmacy] = nil
    flash.now[:notice] = "You have been logged out successfully"
    redirect_to pharmacist_login_url
  end
end

class Admin::Auth::SessionsController < Admin::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  layout 'admin/session'
  
  def new
    @admin_session = AdminSession.new
  end
  
  def create
    @admin_session = AdminSession.new(params[:admin_session])
    
    if @admin_session.save
      flash.now[:notice] = "Login successful"
      redirect_to admin_root_url
    else
      if @admin_session.attempted_record && !@admin_session.attempted_record.active?
        flash[:error] = "Your account has not yet been activated"
        redirect_to admin_new_activation_url(:admin_id => @admin_session.attempted_record)
      else
        flash.now[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end
  
  def destroy
    current_admin_session.destroy
    session[:current_pharmacy] = nil
    flash[:notice] = "You have been logged out successfully"
    redirect_to admin_login_url
  end
end

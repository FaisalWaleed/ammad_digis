class Admin::Auth::Password::ResetsController < Admin::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth
  
  layout 'admin/session'
  
  before_action :load_admin_using_perishable_token, :only => [:edit, :update]
  
  def new
  end
  
  def create
    @admin = Admin.find_by(:email => params[:email])
    if @admin
      AdminMailer.password_recovery_instructions(@admin).deliver_now
      flash[:notice] = "Instructions to reset your password have been sent to your email"
      redirect_to admin_login_url
    else
      flash[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @admin.password = params[:password]
    @admin.password_confirmation = params[:password]
    
    if @admin
      if @admin.save_without_session_maintenance
        AdminMailer.password_recovery_success(@admin).deliver_now
        flash[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to admin_login_url
      else
        AdminMailer.password_recovery_fail(@admin).deliver_now
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end
  
  
  private
  
  def load_admin_using_perishable_token
    @admin = Admin.find_using_perishable_token(params[:token], 1.week)
    unless @admin
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to admin_login_url
    end
  end
end

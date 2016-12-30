class Technician::Auth::Password::ResetsController < Technician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  layout 'technician/session'
  
  before_action :load_technician_using_perishable_token, :only => [:edit, :update]
  
  def new
  end

  def create
    @technician = Technician.find_by(:email_primary => params[:email])
    if @technician
      unless @technician.active?
        flash[:error] = "Please activate your account first."
      else
        @technician.reset_perishable_token!
        
        begin
          TechnicianMailer.password_recovery_instructions(@technician).deliver_now
          flash[:notice] = "Instructions to reset your password have been sent to your email"
        rescue
          flash[:error] = "An error occurred. Please wait a few minutes and try again."
        end
      end
      redirect_to technician_login_url
    else
      flash.now[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @technician.password = params[:password]
    @technician.password_confirmation = params[:password]
    
    if @technician
      if @technician.save_without_session_maintenance
        begin
          TechnicianMailer.password_recovery_success(@technician).deliver_now
        rescue
          
        end
        flash.now[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to technician_login_url
      else
        flash.now[:error] = "It appears your password has an invalid format. Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol."
        
        begin
          TechnicianMailer.password_recovery_fail(@technician).deliver_now
        rescue
        end
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end
  
  
  private
  
  def load_technician_using_perishable_token
    @technician = Technician.find_using_perishable_token(params[:token], 1.week)
    unless @technician
      flash.now[:error] = "We're sorry, but we could not locate your account"
      redirect_to technician_login_url
    end
  end
end

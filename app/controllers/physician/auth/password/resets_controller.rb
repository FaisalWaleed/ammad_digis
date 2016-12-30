class Physician::Auth::Password::ResetsController < Physician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  layout 'physician/session'
  
  before_action :load_physician_using_perishable_token, :only => [:edit, :update]
  
  def new
  end

  def create
    @physician = Physician.find_by(:email_primary => params[:email])
    if @physician
      unless @physician.active?
        flash[:error] = "Please activate your account first."
      else
        @physician.reset_perishable_token!
        
        begin
          PhysicianMailer.password_recovery_instructions(@physician).deliver_now
          flash[:notice] = "Instructions to reset your password have been sent to your email"
        rescue
          flash[:error] = "An error occurred. Please wait a few minutes and try again."
        end
      end

      redirect_to physician_login_url
    else
      flash.now[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @physician.password = params[:password]
    @physician.password_confirmation = params[:password]
    
    if @physician
      if @physician.save_without_session_maintenance
        begin
          PhysicianMailer.password_recovery_success(@physician).deliver_now
        rescue
        end
        flash[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to physician_login_url
      else
        flash.now[:error] = "It appears your password has an invalid format. Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol."
        
        begin
          PhysicianMailer.password_recovery_fail(@physician).deliver_now
        rescue
        end
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end

  private
  
  def load_physician_using_perishable_token
    @physician = Physician.find_using_perishable_token(params[:token], 1.week)
    unless @physician
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to physician_login_url
    end
  end
end

class Pharmacy::Auth::Password::ResetsController < Pharmacy::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  layout 'pharmacy/session'
  
  before_action :load_pharmacy_using_perishable_token, :only => [:edit, :update]
  
  skip_before_action :require_active_subscription

  def new
  end

  def create
    @pharmacy = Pharmacy.find_by(:email_primary => params[:email])
    if @pharmacy
      unless @pharmacy.active?
        flash[:error] = "Please activate your account first."
      else
        @pharmacy.reset_perishable_token!
        
        begin
          PharmacyMailer.password_recovery_instructions(@pharmacy).deliver_now
          flash[:notice] = "Instructions to reset your password have been sent to your email"
        rescue
          flash[:error] = "An error occurred. Please wait a few minutes and try again."
        end
      end
      redirect_to pharmacy_login_url
    else
      flash.now[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @pharmacy.password = params[:password]
    @pharmacy.password_confirmation = params[:password]
    
    if @pharmacy
      if @pharmacy.save_without_session_maintenance
        begin
          PharmacyMailer.password_recovery_success(@pharmacy).deliver_now
        rescue
        end
        flash[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to pharmacy_login_url
      else
        flash.now[:error] = "It appears your password has an invalid format. Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol."
        
        begin
          PharmacyMailer.password_recovery_fail(@pharmacy).deliver_now
        rescue
        end
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end
  
  
  private
  
  def load_pharmacy_using_perishable_token
    @pharmacy = Pharmacy.find_using_perishable_token(params[:token], 1.week)
    unless @pharmacy
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to pharmacy_login_url
    end
  end
end

class Patient::Auth::ResetsController < Patient::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  layout 'patient/session'
  
  before_action :patient_using_perishable_token, :only => [:edit, :update]

  def create
    @patient = Patient.find_by(:email_primary => params[:email])
    if @patient
      unless @patient.active?
        flash[:error] = "Please activate your account first."
      else
        @patient.reset_perishable_token!
        
        # begin
          PatientMailer.password_recovery_instructions(@patient).deliver_now
          flash[:notice] = "Instructions to reset your password have been sent to your email"
        # rescue
          flash[:error] = "An error occurred. Please wait a few minutes and try again."
        # end
      end
      
      redirect_to patient_login_url
    else
      flash.now[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @patient.password = params[:password]
    @patient.password_confirmation = params[:password]
    
    if @patient
      if @patient.save_without_session_maintenance
        begin
          PatientMailer.password_recovery_success(@patient).deliver_now
        rescue
        end
        flash[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to patient_login_url
      else
        flash.now[:error] = "It appears your password has an invalid format. Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol."
        begin
          PatientMailer.password_recovery_fail(@patient).deliver_now
        rescue
        end
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end

  private
  
  def patient_using_perishable_token
    @patient = Patient.find_using_perishable_token(params[:token], 1.week)
    unless @patient
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to patient_login_url
    end
  end
end

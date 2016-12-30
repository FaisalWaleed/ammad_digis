# class Patient::Auth::SessionsController < Patient::BaseController
# #   before_action :require_no_auth, :only => [ :new, :create ]
#   before_action :require_auth, :only => [ :destroy ]
  
#   before_action :get_type_name, :only => [ :new, :create ]
  
#   skip_before_action :require_profile, :only => [ :destroy ]
  
# #   layout 'patient/session'

#   def new
#     @patient_session = PatientSession.new
#   end

#   def create
#     @type = @type_name.classify.constantize.find_by(prescription_params)
    
#     if @type
#       @patient = @type.patient
#       @patient.reset_persistence_token!
      
#       @patient_session = PatientSession.new(@patient, true)
      
#       if @patient_session.save
#         flash[:notice] = "Login successful"

#         redirect_to send("edit_patient_#{@type_name}_path", @type)
#       else
#         flash[:error] = "Sorry, that information appears to be invalid. Please try again."
#         redirect_to patient_login_url(type: @type_name)
#       end
#     else
#       flash[:error] = "Sorry, that information appears to be invalid. Please try again."
#       redirect_to patient_login_url(type: @type_name)
#     end
#   end
  
#   def destroy
#     current_patient_session.destroy
#     session[:current_pharmacy] = nil
#     flash[:notice] = "You have been logged out successfully"
#     redirect_to patient_login_url
#   end
  
#   private
  
#   def prescription_params
#     params.require(:prescription).permit(
#       :identifier,
#       :verification_pin
#     )
#   end
  
#   def get_type_name
#     @type_name = (['prescription', 'diagnostic'] & [params[:type]]).first || 'prescription'
#   end
# end

class Patient::Auth::SessionsController < Patient::BaseController
  # before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]

  skip_before_action :require_profile, :only => [ :destroy ]
  
  skip_before_action :require_active_subscription
  
  layout 'patient/session'
  
  def new
    @patient_session = PatientSession.new
  end

  def create
    @patient_session = PatientSession.new(params[:patient_session])
    if @patient_session.save
      flash.now[:notice] = "Login successful"
      redirect_to patient_root_url
    else
      if @patient_session.attempted_record && !@patient_session.attempted_record.active?
        flash.now[:error] = "Your account has not yet ben activated"
        redirect_to patient_new_activation_url(:patient_id => @patient_session.attempted_record)
      else
        flash.now[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_patient_session.destroy
    flash.now[:notice] = "You have been logged out successfully"
    redirect_to patient_login_url
  end
end

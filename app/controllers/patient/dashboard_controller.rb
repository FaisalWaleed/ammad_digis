class Patient::DashboardController < Patient::BaseController
  layout proc{|c| c.request.xhr? ? false : "patient/new_dashboard" }

  before_action :set_patient  
  before_action :valid_password, only: :changed_password

  def index
  end

  def profile
  end

  def update_info
    respond_to do |format|
      if @patient.update(update_info_params)
        format.html { redirect_to patient_root_url, notice: 'Patient was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def change_password
  end

  def changed_password
    @patient.password = params[:patient][:password]
    @patient.password_confirmation = params[:patient][:password_confirmation]

    if @patient.changed? && @patient.save
      redirect_to patient_root_url, notice: 'Patient successfully updated'
    else
      render :change_password, alert: 'Passowrd mismatch'
    end
  end

  def prescription_details
    @prescription = Prescription.find(params[:id])
  end

  def permissions
    @authorized_physicians = @patient.authorized_physicians.includes(:specialization).active
    @physicians = Physician.includes(:specialization).where.not(id: @authorized_physicians.pluck(:id)).active
  end

  def update_permission
    @patient.authorized(params[:physician_ids]) if params[:permission_action] == 'authorized'
    @patient.unauthorized(params[:physician_ids]) if params[:permission_action] == 'unauthorized'

    redirect_to permissions_patient_dashboard_index_path, notice: 'Permission updated successfully'
  end

  def patient_history
    @prescriptions = current_patient.prescriptions.includes(:physician, :pharmacy)
    @diagnostics = current_patient.diagnostics.includes(:physician, :laboratory)
  end

  private
    def update_info_params
      params.require(:patient).permit(:firstname, :middlename, :lastname, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :avatar)
    end

    def set_patient
      @patient = current_patient
    end

    def valid_password
      redirect_to change_password_patient_dashboard_index_path, alert: "Invalid old password" unless @patient.valid_password?(params[:patient][:old_password])
    end
end

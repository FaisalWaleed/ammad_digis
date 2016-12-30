class Patient::PrescriptionsController < Patient::BaseController
  before_action :require_auth
  before_action :set_prescription, :except => [ :index ]
  
  def index
  end

  def edit
    unless @prescription.transferrable?
      redirect_to patient_prescription_path(@prescription)
    end
  end

  def show
    if @prescription.transferrable?
      redirect_to edit_patient_prescription_path(@prescription)
    end
  end
  
  def update
    if @prescription.update_attributes(prescription_params)
      flash[:success] = "Prescription details updated successfully"
    else
      flash[:error] = "Prescription update failed"
    end
    
    redirect_to patient_prescription_path(@prescription)
  end
  
  private
  
  def set_prescription
    begin
      @prescription = current_patient.prescriptions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "It seems you do not own the prescription you are attempting to access. Please recheck your prescription number and verification pin. Thank you."
      
      current_patient_session.destroy
      
      redirect_to patient_login_url
    end
  end
  
  def prescription_params
    params.require(:prescription).permit(
        :pharmacy_id,
        :pharmacy_name
      )
  end
end

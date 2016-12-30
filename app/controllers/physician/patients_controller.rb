class Physician::PatientsController < Physician::BaseController
  
  before_action :load_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @term = params[:term]
    
    @patients = current_physician.patients.all
    
    if @term.present?
      @patients = @patients.where(
        'patients.firstname ILIKE ? OR patients.lastname ILIKE ?', "#{@term}%", "#{@term}%"
      )
    end
    
    @patients = @patients.page(@page).per(@per_page)
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = current_physician.patients.build
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = current_physician.patients.build(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to [:physician, @patient], notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { request.xhr?? render(nothing: true) : redirect_to([:physician, @patient], notice: 'Patient was successfully updated.') }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to physician_patients_url, notice: 'Patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_note
    @patient = current_physician.patients.find(params[:patient_id])
    
    @patient.update_attributes(patient_params)
    
    render :partial => 'partials/infobar_note', :collection => @patient.notes.reverse, :as => :note
  end

  def add_patient
    @patient = current_physician.patients.new(patient_params)
    
    if @patient.save
      unless request.xhr?
        render partial: "layouts/physician/client_ui"
      else
        render json: { status: 302, redirect_url: physician_patient_path(@patient) }
      end
    else
      unless request.xhr?
        render partial: "layouts/physician/client_ui"
      else
        render json: { status: 422, message: "Failed saving patient" }
      end
    end
  end
  
  def set_patient
    @patient = current_physician.patients.find(params[:id])
    
    unless request.xhr?
      render partial: "layouts/physician/client_ui"
    else
      render json: { status: 302, redirect_url: physician_patient_path(@patient) }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def load_patient
      @patient = current_physician.patients.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :personal_id_type_id, :personal_id_code, :avatar, :name, :address,
      :allergies => [],
      :illnesses => [],
      :notes_attributes => [ :note, :author_type, :author_id, :patient_note_type_id ])
    end
end

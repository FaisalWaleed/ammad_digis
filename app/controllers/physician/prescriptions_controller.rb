class Physician::PrescriptionsController < Physician::BaseController
  layout proc{ |c| c.request.xhr? ? false : ([:edit, :new, :create, :update].include?(c.action_name.to_sym) ? "physician/prescription" : "physician/dashboard") }
  
  before_action :load_prescription, only: [:show, :edit, :update, :destroy]
  
  before_action :load_patient, only: [ :new, :create, :index ]
  
  # GET /prescriptions
  # GET /prescriptions.json
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @term = params[:term]
    @order_by = params[:order_by] || 'created_at'
    @order_dir = params[:order_dir] || 'DESC'
    @start_date = params[:start_date].to_date rescue nil
    @end_date = params[:end_date].to_date rescue nil
    
    @prescriptions = current_physician.prescriptions.includes(:patient, :pharmacy, :drugs).uniq.order("#{@order_by} #{@order_dir}")
    
    if @patient.present?
      @prescriptions = @prescriptions.where(patient: @patient)
    end
    
    if @term.present?
      @prescriptions = @prescriptions.joins('LEFT OUTER JOIN patients ON prescriptions.patient_id = patients.id')
      @prescriptions = @prescriptions.joins('LEFT OUTER JOIN pharmacies ON prescriptions.pharmacy_id = pharmacies.id')
      @prescriptions = @prescriptions.joins('LEFT OUTER JOIN prescripts ON prescripts.prescription_id = prescriptions.id INNER JOIN drugs ON prescripts.drug_id = drugs.id')
      
      @prescriptions = @prescriptions.where(
        'prescriptions.identifier = ? OR patients.firstname ILIKE ? OR patients.lastname ILIKE ? OR pharmacies.name ILIKE ? OR drugs.generic_name ILIKE ?', "#{@term}", "#{@term}%", "#{@term}%", "#{@term}%", "%#{@term}%"
      )
    end
    
    if @start_date
      @prescriptions = @prescriptions.where('prescriptions.created_at >= ?', @start_date)
    end
    
    if @end_date
      @prescriptions = @prescriptions.where('prescriptions.created_at <= ?', @end_date)
    end
    
    @prescriptions = @prescriptions.page(@page).per(@per_page)
  end
  
  # GET /prescriptions/1
  # GET /prescriptions/1.json
  def show
    @patient = @prescription.patient
    
    respond_to do |format|
      format.html do |html|
        html.print do
          @prescription.mark_as_printed!
          render layout: 'prescription-print'
        end
      end
    end
  end
  
  # GET /prescriptions/new
  def new
    @prescription = current_physician.prescriptions.build(:patient_id => params[:patient_id])
  end
  
  # GET /prescriptions/1/edit
  def edit
    #flash[:error] = "Editing a dispatched prescription is not allowed"
  end
  
  # POST /prescriptions
  # POST /prescriptions.json
  def create
    @prescription = current_physician.prescriptions.build(prescription_params)
    
    respond_to do |format|
      if @prescription.save
        format.html { redirect_to [:physician, @prescription], notice: 'Prescription was successfully created.' }
        format.json { render :show, status: :created, location: @prescription }
      else
        format.html { render :new }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /prescriptions/1
  # PATCH/PUT /prescriptions/1.json
  def update
    respond_to do |format|
      if @prescription.pharmacy_id.present?
        format.html { redirect_to [:physician, @prescription], notice: "Editing a dispatched prescription is not allowed" }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      else
        if @prescription.update(prescription_params)
          format.html { redirect_to [:physician, @prescription], notice: 'Prescription was successfully updated.' }
          format.json { render :show, status: :ok, location: @prescription }
        else
          format.html { render :edit }
          format.json { render json: @prescription.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  # DELETE /prescriptions/1
  # DELETE /prescriptions/1.json
  def destroy
    @prescription.destroy
    respond_to do |format|
      format.html { redirect_to physician_prescriptions_url, notice: 'Prescription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_patient
    @patient = current_physician.patients.new(patient_params)
    
    if @patient.save
      @prescription = @patient.prescriptions.build(physician_id: current_physician.id)
    else
      @prescription = current_physician.prescriptions.build
      @prescription.build_patient @patient.attributes
    end
    
    render partial: "layouts/physician/client_ui"
  end
  
  def set_patient
    @prescription = current_physician.prescriptions.build(prescription_params)
    render partial: "layouts/physician/client_ui"
  end
  
  def set_pharmacy
    @prescription = current_physician.prescriptions.find(params[:prescription_id])
    @prescription.update_attributes(pharmacy_id: params[:pharmacy_id], insurer_ids: params[:insurer_ids], send_to_patient: params[:send_to_patient], allow_generic: params[:allow_generic])
    
    @patient = @prescription.patient
    
    unless request.xhr?
      render partial: 'pharmacy_fields'
    else
      flash[:notice] = "Prescription updated successfully"
      render json: { status: 302, redirect_url: physician_prescription_path(@prescription), prescription: @prescription.as_json({
        only: [ :id, :identifier ],
        methods: [ :send_to_patient ]
      }) }
    end
  end
  
  def set_drug
    if params[:prescription][:id].present?
      @prescription =  current_physician.prescriptions.find(params[:prescription][:id])
      
      @prescription.prescripts.where('prescripts.id IN (?)', prescription_params[:prescripts_attributes].map{ |p| p[1]["id"] if p[1]["_destroy"] == '1' }.compact.flatten.uniq).destroy_all
      
      @prescription.prescripts.build(prescription_params[:prescripts_attributes].map { |k,v| v.slice!(:_destroy) }.select{ |p| p[:id].nil? })
    else
      @prescription = current_physician.prescriptions.build(prescription_params)
    end
    
    render partial: "form"
  end
  
  def set_prescript_note
    @prescription = current_physician.prescriptions.find(params[:prescription_id])
    @prescription.update_attributes(prescription_params)
    render partial: "pharmacy_fields"
  end
  
  private
  
  def load_patient
    @patient = current_physician.patients.find(params[:patient_id]) rescue nil
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def load_prescription
    @prescription = current_physician.prescriptions.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def prescription_params
    params.require(:prescription).permit(:identifier,
                                         :id,
                                         :patient_id,
                                         :pharmacy_id,
                                         :patient_name,
                                         :pharmacy_name,
                                         :note,
                                         :insurer_ids => [],
                                         :prescripts_attributes => [
                                                                    :id,
                                                                    :drug_id,
                                                                    :drug_name,
                                                                    :dose,
                                                                    :dosage_unit_id,
                                                                    :dosage_route_id,
                                                                    :dosage_frequency_id,
                                                                    :dosage_duration,
                                                                    :duration_with_unit,
                                                                    :repeat_max,
                                                                    :note,
                                                                    :free_flow_details,
                                                                    :free_flow,
                                                                    :_destroy
                                                                   ])
  end
  
  def patient_params
    params.require(:patient).permit(:name, :address, :firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :personal_id_type_id, :personal_id_code, :avatar, :allow_generic)
  end
end

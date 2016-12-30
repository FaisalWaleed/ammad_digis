class Physician::DiagnosticsController < Physician::BaseController
  
  layout proc{ |c| c.request.xhr? ? false : ([:edit, :new, :create, :update, :show].include?(c.action_name.to_sym) ? "physician/diagnostics" : "physician/dashboard") }
  
  before_action :load_diagnostic, only: [:show, :edit, :update, :destroy]
  before_action :load_patient, only: [ :new, :create, :index ]
  
  # GET /diagnostics
  # GET /diagnostics.json
  def index
    @per_page = params[:per_page] || 10
    @page = params[:page] || 1
    @status = params[:status]
    @term = params[:term]
    @start_date = params[:start_date].to_date rescue nil
    @end_date = params[:end_date].to_date rescue nil
    
    @diagnostics = current_physician.diagnostics.order(created_at: :desc)
    
    if @status == 'archived'
      @diagnostics = @diagnostics.archived_for_physician
    end
    
    if @patient.present?
      @diagnostics = @diagnostics.where(patient: @patient)
    end
    
    if @term.present?
      @diagnostics = @diagnostics.joins('LEFT OUTER JOIN patients ON diagnostics.patient_id = patients.id')
      @diagnostics = @diagnostics.joins('LEFT OUTER JOIN laboratories ON diagnostics.laboratory_id = laboratories.id')
      
      @diagnostics = @diagnostics.where(
        'diagnostics.identifier = ? OR patients.firstname ILIKE ? OR patients.lastname ILIKE ? OR laboratories.name ILIKE ?', "#{@term}", "#{@term}%", "#{@term}%", "#{@term}%"
      )
    end
    
    if @start_date
      @diagnostics = @diagnostics.where('diagnostics.created_at >= ?', @start_date)
    end
    
    if @end_date
      @diagnostics = @diagnostics.where('diagnostic.created_at <= ?', @end_date)
    end
    
    @diagnostics = @diagnostics.page(@page).per(@per_page)
  end

  # GET /diagnostics/1
  # GET /diagnostics/1.json
  def show
    @tags = TestTag.with_diagnostic(@diagnostic)
    @profiles = @diagnostic.profiled_testings.group_by(&:test_profile)
  end

  # GET /diagnostics/new
  def new
    @diagnostic = current_physician.diagnostics.build(:patient_id => params[:patient_id])
  end

  # GET /diagnostics/1/edit
  def edit
  end

  # POST /diagnostics
  # POST /diagnostics.json
  def create
    diagnostic_params[:profiled_testings_attributes] = diagnostic_params[:profiled_testings_attributes].delete_if { |k,v| v[:_permit] != '1' }
    @diagnostic = current_physician.diagnostics.build(diagnostic_params)

    respond_to do |format|
      if @diagnostic.save
        format.html { redirect_to [:physician, @diagnostic], notice: 'Diagnostic was successfully created.' }
        format.json { render :show, status: :created, location: [:physician, @diagnostic] }
      else
        format.html { render :new }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diagnostics/1
  # PATCH/PUT /diagnostics/1.json
  def update
    respond_to do |format|
      if @diagnostic.update(diagnostic_params)
        format.html { redirect_to [:physician, @diagnostic], notice: 'Diagnostic was successfully updated.' }
        format.json { render :show, status: :ok, location: [:physician, @diagnostic] }
      else
        format.html { render :edit }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diagnostics/1
  # DELETE /diagnostics/1.json
  def destroy
    @diagnostic.destroy
    respond_to do |format|
      format.html { redirect_to physician_diagnostics_path, notice: 'Diagnostic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_patient
    @patient = current_physician.patients.new(patient_params)
    
    if @patient.save
      @diagnostic = @patient.diagnostics.build(physician_id: current_physician.id)
    else
      @diagnostic = current_physician.diagnostics.build
      @diagnostic.build_patient @patient.attributes
    end
    
    render partial: "layouts/physician/diagnostic_ui"
  end
  
  def set_patient
    @diagnostic = current_physician.diagnostics.build(diagnostic_params)
    render partial: "layouts/physician/diagnostic_ui"
  end
  
  private
  
  def load_patient
    @patient = current_physician.patients.find(params[:patient_id]) rescue nil
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def load_diagnostic
    @diagnostic = current_physician.diagnostics.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def diagnostic_params
    params.require(:diagnostic).permit(
      :patient_id,
      :send_to_patient,
      :laboratory_id,
      :notes,
      :verification_pin,
      :test_ids => [],
      :profiled_testings_attributes => [
                                        :test_id,
                                        :test_profile_id,
                                        :id,
                                        :_destroy,
                                        :_permit
                                        ]
    )
  end
  
  def patient_params
    params.require(:patient).permit(:name,
                                    :address,
                                    :firstname,
                                    :lastname,
                                    :middlename,
                                    :gender_id,
                                    :date_of_birth,
                                    :address_street_1,
                                    :address_street_2,
                                    :address_municipality,
                                    :address_territory,
                                    :address_postal_code,
                                    :address_country,
                                    :email_primary,
                                    :email_secondary,
                                    :phone_primary,
                                    :phone_secondary,
                                    :phone_mobile,
                                    :phone_alternate,
                                    :personal_id_type_id,
                                    :personal_id_code,
                                    :avatar,
                                    :allow_generic
                                   )
  end
end

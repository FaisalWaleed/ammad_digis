class TestCenter::TechniciansController < TestCenter::BaseController
  before_action :set_technician, only: [:show, :edit, :update, :destroy]
  
  def index
    @technicians = current_test_center.technicians
    
    if @term
      @technicians = @technicians.where('UPPER(technicians.firstname) LIKE ? OR UPPER(technicians.lastname) LIKE ? OR technicians.phone_primary LIKE ? OR UPPER(technicians.email_primary) LIKE ? OR technicians.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term.upcase}%", "#{@term}")
    end
    
    @technicians = @technicians.page(@page).per(@per_page)
  end
  
  def show
  end
  
  def new
    @technician = current_test_center.technicians.build
  end
  
  def edit
  end
  
  def create
    @technician = current_test_center.technicians.build(technician_params)
    
    respond_to do |format|
      if @technician.save
        format.html { redirect_to [:test_center, @technician], notice: 'Technician was successfully created.' }
        format.json { render :show, status: :created, location: [:technician, @technician] }
      else
        format.html { render :new }
        format.json { render json: @technician.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @technician.update(technician_params)
        format.html { redirect_to [:test_center, @technician], notice: 'Technician was successfully updated.' }
        format.json { render :show, status: :ok, location: [:technician, @technician] }
      else
        format.html { render :edit }
        format.json { render json: @technician.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @technician.destroy
    respond_to do |format|
      format.html { redirect_to technician_technicians_url, notice: 'Technician was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_technician
    @technician = current_test_center.technicians.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def technician_params
    params.require(:technician).permit(
      :firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :phone_primary, :reg_num, :avatar, :password, :password_confirmation, :active, :admin, :test_center_ids => [],
      :location_attributes => [
                                :name,
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
                                :fax_primary,
                                :fax_secondary,
                                :latitude,
                                :longitude,
                                :asset_type,
                                :asset_id,
                                :id,
                                :_destroy
                                ]
    ).merge(laboratory_ids: (params[:test_center_ids].blank?? [current_test_center.id] : []))
  end
end

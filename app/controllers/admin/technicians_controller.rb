class Admin::TechniciansController < Admin::BaseController
  before_action :set_technician, only: [:show, :edit, :update, :destroy]

  # GET /technicians
  # GET /technicians.json
  def index
    @technicians = Technician.all
    
    if @term
      @technicians = @technicians.where('UPPER(technicians.firstname) LIKE ? OR UPPER(technicians.lastname) LIKE ? OR technicians.phone_primary LIKE ? OR UPPER(technicians.email_primary) LIKE ? OR technicians.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term.upcase}%", "#{@term}")
    end
    
    @technicians = @technicians.page(@page).per(@per_page)
  end

  # GET /technicians/1
  # GET /technicians/1.json
  def show
  end

  # GET /technicians/new
  def new
    @technician = Technician.new
  end

  # GET /technicians/1/edit
  def edit
  end

  # POST /technicians
  # POST /technicians.json
  def create
    @technician = Technician.new(technician_params)

    respond_to do |format|
      if @technician.save
        format.html { redirect_to admin_technician_path(@technician), notice: 'Technician was successfully created.' }
        format.json { render :show, status: :created, location: admin_technician_path(@technician) }
      else
        format.html { render :new }
        format.json { render json: @technician.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /technicians/1
  # PATCH/PUT /technicians/1.json
  def update
    respond_to do |format|
      if @technician.update(technician_params)
        format.html { redirect_to admin_technician_path(@technician), notice: 'Technician was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_technician_path(@technician) }
      else
        format.html { render :edit }
        format.json { render json: @technician.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /technicians/1
  # DELETE /technicians/1.json
  def destroy
    @technician.destroy
    respond_to do |format|
      format.html { redirect_to admin_technicians_url, notice: 'Technician was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_technician
      @technician = Technician.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def technician_params
      params.require(:technician).permit(:firstname, :middlename, :lastname, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num, :active, :admin, :avatar, :password, :password_confirmation, :laboratory_ids => [])
    end
end

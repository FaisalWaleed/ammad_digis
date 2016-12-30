class Admin::PharmaciesController < Admin::BaseController
  before_action :set_pharmacy, only: [:show, :edit, :update, :destroy]

  # GET /pharmacies
  # GET /pharmacies.json
  def index
    @pharmacies = Pharmacy.all
    
    if @term
      @pharmacies = @pharmacies.where('UPPER(pharmacies.name) LIKE ? OR UPPER(pharmacies.contact_firstname) LIKE ? OR UPPER(pharmacies.contact_lastname) LIKE ? OR UPPER(pharmacies.email_primary) LIKE ? OR pharmacies.phone_primary LIKE ? OR pharmacies.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term}")
    end
    
    @pharmacies = @pharmacies.page(@page).per(@per_page)
  end

  # GET /pharmacies/1
  # GET /pharmacies/1.json
  def show
  end

  # GET /pharmacies/new
  def new
    @pharmacy = Pharmacy.new
  end

  # GET /pharmacies/1/edit
  def edit
  end

  # POST /pharmacies
  # POST /pharmacies.json
  def create
    @pharmacy = Pharmacy.new(pharmacy_params)

    respond_to do |format|
      if @pharmacy.save
        format.html { redirect_to admin_pharmacy_path(@pharmacy), notice: 'Pharmacy was successfully created.' }
        format.json { render :show, status: :created, location: admin_pharmacy_path(@pharmacy) }
      else
        format.html { render :new }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pharmacies/1
  # PATCH/PUT /pharmacies/1.json
  def update
    respond_to do |format|
      if @pharmacy.update(pharmacy_params)
        format.html { redirect_to admin_pharmacy_path(@pharmacy), notice: 'Pharmacy was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_pharmacy_path(@pharmacy) }
      else
        format.html { render :edit }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacies/1
  # DELETE /pharmacies/1.json
  def destroy
    @pharmacy.destroy
    respond_to do |format|
      format.html { redirect_to admin_pharmacies_url, notice: 'Pharmacy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacy
      @pharmacy = Pharmacy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :contact_firstname, :contact_lastname, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :latitude, :longitude, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num)
    end
end

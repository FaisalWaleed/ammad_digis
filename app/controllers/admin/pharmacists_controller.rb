class Admin::PharmacistsController < Admin::BaseController
  before_action :set_pharmacist, only: [:show, :edit, :update, :destroy]

  # GET /pharmacists
  # GET /pharmacists.json
  def index
    @pharmacists = Pharmacist.all
    
    if @term
      @pharmacists = @pharmacists.where('UPPER(pharmacists.firstname) LIKE ? OR UPPER(pharmacists.lastname) LIKE ? OR pharmacists.phone_primary LIKE ? OR UPPER(pharmacists.email_primary) LIKE ? OR pharmacists.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term.upcase}%", "#{@term}")
    end
    
    @pharmacists = @pharmacists.page(@page).per(@per_page)
  end

  # GET /pharmacists/1
  # GET /pharmacists/1.json
  def show
  end

  # GET /pharmacists/new
  def new
    @pharmacist = Pharmacist.new
  end

  # GET /pharmacists/1/edit
  def edit
  end

  # POST /pharmacists
  # POST /pharmacists.json
  def create
    @pharmacist = Pharmacist.new(pharmacist_params)

    respond_to do |format|
      if @pharmacist.save
        format.html { redirect_to admin_pharmacist_path(@pharmacist), notice: 'Pharmacist was successfully created.' }
        format.json { render :show, status: :created, location: admin_pharmacist_path(@pharmacist) }
      else
        format.html { render :new }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pharmacists/1
  # PATCH/PUT /pharmacists/1.json
  def update
    respond_to do |format|
      if @pharmacist.update(pharmacist_params)
        format.html { redirect_to admin_pharmacist_path(@pharmacist), notice: 'Pharmacist was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_pharmacist_path(@pharmacist) }
      else
        format.html { render :edit }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacists/1
  # DELETE /pharmacists/1.json
  def destroy
    @pharmacist.destroy
    respond_to do |format|
      format.html { redirect_to admin_pharmacists_url, notice: 'Pharmacist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacist
      @pharmacist = Pharmacist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacist_params
      params.require(:pharmacist).permit(:firstname, :middlename, :lastname, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num, :active, :admin, :avatar, :password, :password_confirmation, :login, :pharmacy_ids => [])
    end
end

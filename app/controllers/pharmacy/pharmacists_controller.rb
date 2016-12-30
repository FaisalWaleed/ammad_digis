class Pharmacy::PharmacistsController < Pharmacy::BaseController
  
  before_action :set_pharmacist, only: [:show, :edit, :update, :destroy]

  def index
    @pharmacists = current_pharmacy.pharmacists
    
    if @term
      @pharmacists = @pharmacists.where('UPPER(pharmacists.firstname) LIKE ? OR UPPER(pharmacists.lastname) LIKE ? OR pharmacists.phone_primary LIKE ? OR UPPER(pharmacists.email_primary) LIKE ? OR pharmacists.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term.upcase}%", "#{@term}")
    end
    
    @pharmacists = @pharmacists.page(@page).per(@per_page)
  end

  def show
  end

  def new
    @pharmacist = current_pharmacy.pharmacists.build
  end

  def edit
  end

  def create
    @pharmacist = current_pharmacy.pharmacists.build(pharmacist_params)

    respond_to do |format|
      if @pharmacist.save
        format.html { redirect_to [:pharmacy, @pharmacist], notice: 'Pharmacist was successfully created.' }
        format.json { render :show, status: :created, location: [:pharmacist, @pharmacist] }
      else
        format.html { render :new }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @pharmacist.update(pharmacist_params)
        format.html { redirect_to [:pharmacy, @pharmacist], notice: 'Pharmacist was successfully updated.' }
        format.json { render :show, status: :ok, location: [:pharmacist, @pharmacist] }
      else
        format.html { render :edit }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pharmacist.destroy
    respond_to do |format|
      format.html { redirect_to pharmacist_pharmacists_url, notice: 'Pharmacist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacist
      @pharmacist = current_pharmacy.pharmacists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacist_params
      params.require(:pharmacist).permit(
        :firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :phone_primary, :reg_num, :avatar, :password, :password_confirmation, :active, :admin, :pharmacy_ids => []
        ).merge(pharmacy_ids: (params[:pharmacy_ids].blank?? [current_pharmacy.id] : []))
    end
end

class Pharmacist::PharmacistsController < Pharmacist::BaseController
  after_action :verify_authorized #, except: :index
  
  before_action :set_pharmacist, only: [:show, :edit, :update, :destroy]

  # GET /pharmacists
  # GET /pharmacists.json
  def index
    authorize :'Pharmacist::Pharmacist'
    @pharmacists = current_pharmacist.pharmacists
  end

  # GET /pharmacists/1
  # GET /pharmacists/1.json
  def show
    authorize :'Pharmacist::Pharmacist'
  end

  # GET /pharmacists/new
  def new
    authorize :'Pharmacist::Pharmacist'
    @pharmacist = Pharmacist.new
  end

  # GET /pharmacists/1/edit
  def edit
    authorize :'Pharmacist::Pharmacist'
  end

  # POST /pharmacists
  # POST /pharmacists.json
  def create
    authorize :'Pharmacist::Pharmacist'
    @pharmacist = Pharmacist.new(pharmacist_params)

    respond_to do |format|
      if @pharmacist.save
        format.html { redirect_to [:pharmacist, @pharmacist], notice: 'Pharmacist was successfully created.' }
        format.json { render :show, status: :created, location: [:pharmacist, @pharmacist] }
      else
        format.html { render :new }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pharmacists/1
  # PATCH/PUT /pharmacists/1.json
  def update
    authorize :'Pharmacist::Pharmacist'
    respond_to do |format|
      if @pharmacist.update(pharmacist_params)
        format.html { redirect_to [:pharmacist, @pharmacist], notice: 'Pharmacist was successfully updated.' }
        format.json { render :show, status: :ok, location: [:pharmacist, @pharmacist] }
      else
        format.html { render :edit }
        format.json { render json: @pharmacist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacists/1
  # DELETE /pharmacists/1.json
  def destroy
    authorize :'Pharmacist::Pharmacist'
    
    @pharmacist.destroy
    respond_to do |format|
      format.html { redirect_to pharmacist_pharmacists_url, notice: 'Pharmacist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacist
      @pharmacist = current_pharmacist.pharmacists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacist_params
      params.require(:pharmacist).permit(:firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :phone_primary, :reg_num, :avatar, :password, :password_confirmation, :active, :admin, :pharmacy_ids => [])
    end
end

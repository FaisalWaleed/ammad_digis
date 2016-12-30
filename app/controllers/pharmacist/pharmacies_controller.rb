class Pharmacist::PharmaciesController < Pharmacist::BaseController
  after_action :verify_authorized, except: :index
  
  before_action :set_pharmacy, only: [:show, :edit, :update, :destroy]
  
  skip_before_action :require_active_subscription

  # GET /pharmacies
  # GET /pharmacies.json
  def index
    authorize :'Pharmacist::Pharmacy'
    @pharmacies = current_pharmacist.pharmacies
    current_pharmacy  # NOTE: force setting the session var
  end

  # GET /pharmacies/1
  # GET /pharmacies/1.json
  def show
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
    
    authorize :'Pharmacist::Pharmacy'
    
    @dispense_orders = @pharmacy.dispense_orders
    
    respond_to do |format|
      format.html do
        @dispense_orders = @dispense_orders.page(@page).per(@per)
      end
      
      format.csv do
        content = CSV.generate do |csv|
          csv << ["Rx#", "Status"]
          
          for d in @dispense_orders
            csv << [
              d.identifier,
              d.status,
            ]
          end
        end
        
        send_data content, 
		  :type => 'text/csv; charset=iso-8859-1; header=present', 
          :disposition => "attachment; filename=prescriptions.csv" 
      end
    end
  end

  # GET /pharmacies/new
  def new
    authorize :'Pharmacist::Pharmacy'
    @pharmacy = current_pharmacist.pharmacies.new
  end

  # GET /pharmacies/1/edit
  def edit
    authorize :'Pharmacist::Pharmacy'
  end

  # POST /pharmacies
  # POST /pharmacies.json
  def create
    authorize :'Pharmacist::Pharmacy'
    @pharmacy = Pharmacy.new(pharmacy_params.merge(pharmacist_ids: [current_pharmacist.id]))

    respond_to do |format|
      if @pharmacy.save
        format.html { redirect_to [:pharmacist, @pharmacy], notice: 'Pharmacy was successfully created.' }
        format.json { render :show, status: :created, location: [:pharmacist, @pharmacy] }
      else
        format.html { render :new }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pharmacies/1
  # PATCH/PUT /pharmacies/1.json
  def update
    authorize :'Pharmacist::Pharmacy'
    respond_to do |format|
      if @pharmacy.update(pharmacy_params)
        format.html { redirect_to [:pharmacist, @pharmacy], notice: 'Pharmacy was successfully updated.' }
        format.json { render :show, status: :ok, location: [:pharmacist, @pharmacy] }
      else
        format.html { render :edit }
        format.json { render json: @pharmacy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacies/1
  # DELETE /pharmacies/1.json
  def destroy
    authorize :'Pharmacist::Pharmacy'
    @pharmacy.destroy
    respond_to do |format|
      format.html { redirect_to pharmacist_pharmacies_url, notice: 'Pharmacy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pharmacy
      @pharmacy = current_pharmacist.pharmacies.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pharmacy_params
      params.require(:pharmacy).permit(:name, :contact_firstname, :contact_lastname, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :latitude, :longitude, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :reg_num)
    end
end

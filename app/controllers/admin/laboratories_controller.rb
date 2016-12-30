class Admin::LaboratoriesController < Admin::BaseController
  before_action :set_laboratory, only: [:show, :edit, :update, :destroy]

  # GET /laboratories
  # GET /laboratories.json
  def index
    @laboratories = Laboratory.all
    
    if @term
      @laboratories = @laboratories.where('UPPER(laboratories.name) LIKE ? OR UPPER(laboratories.contact_firstname) LIKE ? OR UPPER(laboratories.contact_lastname) LIKE ? OR UPPER(laboratories.email_primary) LIKE ? OR laboratories.phone_primary LIKE ? OR laboratories.reg_num = ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%", "#{@term}%", "#{@term}")
    end
    
    @laboratories = @laboratories.page(@page).per(@per_page)
  end

  # GET /laboratories/1
  # GET /laboratories/1.json
  def show
  end

  # GET /laboratories/new
  def new
    @laboratory = Laboratory.new
  end

  # GET /laboratories/1/edit
  def edit
  end

  # POST /laboratories
  # POST /laboratories.json
  def create
    @laboratory = Laboratory.new(laboratory_params)

    respond_to do |format|
      if @laboratory.save
        format.html { redirect_to admin_laboratory_path(@laboratory), notice: 'Laboratory was successfully created.' }
        format.json { render :show, status: :created, location: admin_laboratory_path(@laboratory) }
      else
        format.html { render :new }
        format.json { render json: @laboratory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /laboratories/1
  # PATCH/PUT /laboratories/1.json
  def update
    respond_to do |format|
      if @laboratory.update(laboratory_params)
        format.html { redirect_to admin_laboratory_path(@laboratory), notice: 'Laboratory was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_laboratory_path(@laboratory) }
      else
        format.html { render :edit }
        format.json { render json: @laboratory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laboratories/1
  # DELETE /laboratories/1.json
  def destroy
    @laboratory.destroy
    respond_to do |format|
      format.html { redirect_to admin_laboratories_url, notice: 'Laboratory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laboratory
      @laboratory = Laboratory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def laboratory_params
      params.require(:laboratory).permit(:name, :contact_firstname, :contact_lastname, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :latitude, :longitude, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num, :test_type_ids => [])
    end
end

class Admin::DrugsController < Admin::BaseController
  before_action :set_drug, only: [:show, :edit, :update, :destroy]

  # GET /drugs
  # GET /drugs.json
  def index
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
    
    @drugs = Drug.all
    
    if @term
      @drugs = @drugs.joins(:drug_format).where('UPPER(drugs.trade_name) LIKE ? OR UPPER(drugs.generic_name) LIKE ? OR UPPER(drug_formats.name) LIKE ?', "#{@term.upcase}%", "#{@term.upcase}%", "#{@term.upcase}%")
    end
    
    @drugs = @drugs.page(@page).per(@per_page)
  end

  # GET /drugs/1
  # GET /drugs/1.json
  def show
  end

  # GET /drugs/new
  def new
    @drug = Drug.new
  end

  # GET /drugs/1/edit
  def edit
  end

  # POST /drugs
  # POST /drugs.json
  def create
    @drug = Drug.new(drug_params)

    respond_to do |format|
      if @drug.save
        format.html { redirect_to admin_drug_path(@drug), notice: 'Drug was successfully created.' }
        format.json { render :show, status: :created, location: admin_drug_path(@drug) }
      else
        format.html { render :new }
        format.json { render json: @drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drugs/1
  # PATCH/PUT /drugs/1.json
  def update
    respond_to do |format|
      if @drug.update(drug_params)
        format.html { redirect_to admin_drug_path(@drug), notice: 'Drug was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_drug_path(@drug) }
      else
        format.html { render :edit }
        format.json { render json: @drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drugs/1
  # DELETE /drugs/1.json
  def destroy
    @drug.destroy
    respond_to do |format|
      format.html { redirect_to admin_drugs_url, notice: 'Drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drug
      @drug = Drug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drug_params
      params.require(:drug).permit(:trade_name, :generic_name, :drug_format_id, :dosages, :dosage_route_ids => [])
    end
end

class Admin::PlansController < Admin::BaseController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
    
    if @term
      @plans = @plans.where('UPPER(plans.name) LIKE ?', "#{@term.upcase}%")
    end
    
    @plans = @plans.page(@page).per(@per_page)
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to [:admin, @plan], notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @plan] }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to [:admin, @plan], notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @plan] }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to admin_plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:name, :description, :available_to_physician, :available_to_pharmacy, :available_to_patient, :available_to_technician, :price, :subscription_period_amount, :subscription_period_unit, :grace_period_amount, :grace_period_unit, :trial_period_amount, :trial_period_unit, :renew_notify, :auto_renew, :published, :default, :subscriber_limit, :organization_limit)
    end
end

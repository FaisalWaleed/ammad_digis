class Admin::TestsController < Admin::BaseController
  before_action :set_test, only: [:show, :edit, :update, :destroy]

  # GET /tests
  # GET /tests.json
  def index
    @tests = Test.order(:id)
    
    if @term
      @tests = @tests.joins(:test_type).where('UPPER(tests.name) LIKE ? OR UPPER(test_types.name) LIKE ?', "#{@term.upcase}%", "#{@term.upcase}%")
    end
    
    @tests = @tests.page(@page).per(@per_page)
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
  end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)

    respond_to do |format|
      if @test.save
        format.html { redirect_to admin_test_path(@test), notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: admin_test_path(@test) }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to admin_test_path(@test), notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_test_path(@test) }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to admin_tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(
        :name,
        :test_type_id,
        :test_type_name,
        :test_tag_names,
        :test_tag_ids => []
      )
    end
end

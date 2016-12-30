class Admin::TestProfilesController < Admin::BaseController
  before_action :set_test_profile, only: [:show, :edit, :update, :destroy]

  # GET /test_profiles
  # GET /test_profiles.json
  def index
    @test_profiles = TestProfile.all
    
    if @term
      @test_profiles = @test_profiles.joins(:test_type).where('UPPER(test_profiles.name) LIKE ? OR UPPER(test_types.name) LIKE ?', "#{@term.upcase}%", "#{@term.upcase}%")
    end
    
    @test_profiles.page(@page).per(@per_page)
  end

  # GET /test_profiles/1
  # GET /test_profiles/1.json
  def show
  end

  # GET /test_profiles/new
  def new
    @test_profile = TestProfile.new
  end

  # GET /test_profiles/1/edit
  def edit
  end

  # POST /test_profiles
  # POST /test_profiles.json
  def create
    @test_profile = TestProfile.new(test_profile_params)

    respond_to do |format|
      if @test_profile.save
        format.html { redirect_to admin_test_profile_path(@test_profile), notice: 'Test profile was successfully created.' }
        format.json { render :show, status: :created, location: admin_test_profile_path(@test_profile) }
      else
        format.html { render :new }
        format.json { render json: @test_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_profiles/1
  # PATCH/PUT /test_profiles/1.json
  def update
    respond_to do |format|
      if @test_profile.update(test_profile_params)
        format.html { redirect_to admin_test_profile_path(@test_profile), notice: 'Test profile was successfully updated.' }
        format.json { render :show, status: :ok, location: admin_test_profile_path(@test_profile) }
      else
        format.html { render :edit }
        format.json { render json: @test_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_profiles/1
  # DELETE /test_profiles/1.json
  def destroy
    @test_profile.destroy
    respond_to do |format|
      format.html { redirect_to admin_test_profiles_url, notice: 'Test profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_profile
      @test_profile = TestProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_profile_params
      params.require(:test_profile).permit(
        :name,
        :test_type_id,
        :test_type_name,
        :test_ids => []
      )
    end
end

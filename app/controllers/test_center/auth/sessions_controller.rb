class TestCenter::Auth::SessionsController < TestCenter::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  before_action :require_auth, :only => [ :destroy ]
  
  skip_before_action :require_profile, :only => [ :destroy ]
  
  skip_before_action :require_active_subscription
  
  layout 'test_center/session'
  
  def new
    @test_center_session = TestCenterSession.new
  end

  def create
    @test_center_session = TestCenterSession.new(params[:test_center_session])
    
    if @test_center_session.save
      flash[:notice] = "Login successful"
      redirect_to test_center_root_url
    else
      if @test_center_session.attempted_record && !@test_center_session.attempted_record.active?
        flash[:error] = "Your account has not yet been activated"
        redirect_to test_center_new_activation_url(:test_center_id => @test_center_session.attempted_record)
      else
        flash[:error] = "The supplied username and/or password is incorrect"
        render :action => :new
      end
    end
  end

  def destroy
    current_test_center_session.destroy
    session[:current_laboratory] = nil
    flash[:notice] = "You have been logged out successfully"
    redirect_to test_center_login_url
  end
end

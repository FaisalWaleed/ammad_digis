class TestCenter::Auth::ActivationsController < TestCenter::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  layout 'test_center/session'

  skip_before_action :require_active_subscription
  
  def new
    @test_center = TestCenter.find(params[:test_center_id]) if params[:test_center_id]
  end

  def create
    if params[:activation_code].blank?
      flash[:error] = "You must provide a valid activation URL"
    else
      @test_center = TestCenter.find_using_perishable_token(params[:activation_code], 1.week)
      
      unless @test_center.blank? || @test_center.active?
        if @test_center.activate!
          flash[:notice] = "Your account has been activated!"
          TestCenterSession.create(@test_center, false) # Log test_center in manually
          TestCenterMailer.activation_welcome(@test_center).deliver_now
        end
      else
        flash[:error] = "That account does not exist or has already been activated"
      end
    end
    
    redirect_to test_center_login_url
  end
  
  def resend
    if params[:test_center_id]
      @test_center = TestCenter.find params[:test_center_id]
      if @test_center && !@test_center.active?
        TestCenterMailer.activation_instructions(@test_center).deliver_now
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
      else
        flash[:error] = "Your account is already active!"
      end
    end
    
    redirect_to test_center_login_url
  end
end

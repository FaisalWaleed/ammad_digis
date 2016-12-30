class TestCenter::Auth::Password::ResetsController < TestCenter::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  layout 'test_center/session'
  
  before_action :load_test_center_using_perishable_token, :only => [:edit, :update]
  
  def new
  end

  def create
    @test_center = TestCenter.find_by(:email_primary => params[:email])
    if @test_center
      unless @test_center.active?
        flash[:error] = "Please activate your account first."
      else
        @test_center.reset_perishable_token!
        
        begin
          TestCenterMailer.password_recovery_instructions(@test_center).deliver_now
          flash.now[:notice] = "Instructions to reset your password have been sent to your email"
        rescue
          flash[:error] = "An error occurred. Please wait a few minutes and try again."
        end
      end
      redirect_to test_center_login_url
    else
      flash.now[:error] = "No account was found with email address '#{params[:email]}'"
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    @test_center.password = params[:password]
    @test_center.password_confirmation = params[:password]
    
    if @test_center
      if @test_center.save_without_session_maintenance
        begin
          TestCenterMailer.password_recovery_success(@test_center).deliver_now
        rescue
        end
        flash.now[:success] = "Your password was successfully updated. Please log in with your new password."
        redirect_to test_center_login_url
      else
        flash.now[:error] = "It appears your password has an invalid format. Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol."
        
        begin
          TestCenterMailer.password_recovery_fail(@test_center).deliver_now
        rescue
        end
        render :action => :edit
      end
    else
      render :action => :edit
    end
  end
  
  
  private
  
  def load_test_center_using_perishable_token
    @test_center = TestCenter.find_using_perishable_token(params[:token], 1.week)
    unless @test_center
      flash.now[:error] = "We're sorry, but we could not locate your account"
      redirect_to test_center_login_url
    end
  end
end

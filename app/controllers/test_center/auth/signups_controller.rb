class TestCenter::Auth::SignupsController < TestCenter::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

#   before_action :load_plan, :only => [ :new ]
  before_action :save_plan_id, :only => [ :new ]
  
  skip_before_action :require_active_subscription
  
  protect_from_forgery :except => [:check_email]
  
  layout 'test_center/session'

  def new
    @test_center = TestCenter.new
    
    if @plan
      @subscription = @test_center.subscriptions.build(plan_id: @plan.id)
    end
  end

  def create
    @test_center = TestCenter.new(test_center_params)
    
    if @test_center.save
      begin
        TestCenterMailer.activation_instructions(@test_center).deliver_now
        flash[:notice] = "Registration successful! Please check the account you specified as your primary email for further instructions on completing your account activation."
      rescue
        flash[:error] = "Your account was successfully created, but there was an error sending your activation instructions. Please wait a few minutes and then click the 'resending your activation instructions' button. If the problem persists, please let us know."
      end
      
      redirect_to test_center_login_url
    else
      flash.now[:error] = "Registration failed. Please recheck the supplied information and try again"
      render :action => :new
    end
  end
  
  def check_email
    @test_center = TestCenter.find_by(email_primary: params[:email])
    
    unless @test_center
      respond_to do |format|
        format.html do
          render :text => 'That email has not been taken', :layout => false
        end
        
        format.js do
          render :json => { available: true }
        end
      end
    else
      respond_to do |format|
        format.html do
          render :text => 'That email has already been taken', :layout => false
        end
        
        format.js do
          render :json => { available: false }
        end
      end
    end
  end
  
  private 
  
  def load_plan
    @plan = Plan.published.available_to_laboratory.find(params[:plan_id]) rescue Plan.published.available_to_laboratory.default.random.first
  end
  
  def save_plan_id
    session[:subscribe_plan_id] = params[:plan_id]
  end
  
  def test_center_params
    params.require(:test_center).permit(
      :name,
      :email_primary,
      :email_secondary,
      :phone_primary,
      :phone_secondary,
      :phone_mobile,
      :phone_alternate,
      :address_street_1,
      :address_street_2,
      :address_territory,
      :address_municipality,
      :address_postal_code,
      :address_country,
      :password,
      :password_confirmation,
      :reg_num,
      :avatar,
      :terms_of_service,
      :test_type_ids => [],
      :subscriptions_attributes => [
                                    :plan_id
                                   ]
    )
  end
end

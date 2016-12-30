class Pharmacy::Auth::SignupsController < Pharmacy::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth
  
  protect_from_forgery :except => [:check_email]
  
#   before_action :load_plan, :only => [ :new ]
  before_action :save_plan_id, :only => [ :new ]
  
  layout 'pharmacy/session'

  skip_before_action :require_active_subscription

  def new
    @pharmacy = Pharmacy.new
    
    if @plan
      @subscription = @pharmacy.subscriptions.build(plan_id: @plan.id)
    end
  end

  def create
    @pharmacy = Pharmacy.new(pharmacy_params)
    
    if @pharmacy.save
      begin
        PharmacyMailer.activation_instructions(@pharmacy).deliver_now
        flash[:notice] = "Registration successful! Please check the account you specified as your primary email for further instructions on completing your account activation."
      rescue
        flash[:error] = "Your account was successfully created, but there was an error sending your activation instructions. Please wait a few minutes and then click the 'resending your activation instructions' button. If the problem persists, please let us know."
      end
      
      redirect_to pharmacy_login_url
    else
      flash.now[:error] = "Registration failed. Please recheck the supplied information and try again"
      render :action => :new
    end
  end
  
  def check_email
    @pharmacy = Pharmacy.find_by(email_primary: params[:email])
    
    unless @pharmacy
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
    @plan = Plan.published.available_to_pharmacy.find(params[:plan_id]) rescue Plan.published.available_to_pharmacy.default.random.first
  end
  
  def save_plan_id
    session[:subscribe_plan_id] = params[:plan_id]
  end
  
  def pharmacy_params
    params.require(:pharmacy).permit(
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
      :subscriptions_attributes => [
                                    :plan_id
                                   ]
    )
  end
end

class Physician::Auth::SignupsController < Physician::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  
  before_action :save_subscribe_plan_id, :only => [ :new ]
  after_action :clear_subscribe_plan_id, :only => [ :create ]
  
  skip_before_action :require_auth

  skip_before_action :require_active_subscription
  
  protect_from_forgery :except => [:check_email]
  
  layout 'physician/session'

  def new
    @physician = Physician.new
  end

  def create
    @physician = Physician.new(physician_params)
    
    if @physician.save
      begin
        PhysicianMailer.activation_instructions(@physician).deliver_now
        flash[:notice] = "Registration successful! Please check the account you specified as your primary email for further instructions on completing your account activation."
      rescue
        flash[:error] = "Your account was successfully created, but there was an error sending your activation instructions. Please wait a few minutes and then click the 'resending your activation instructions' button. If the problem persists, please let us know."
      end
      
      redirect_to physician_login_url
    else
      flash.now[:error] = "Registration failed. Please recheck the supplied information and try again"
      render :action => :new
    end
  end
  
  def check_email
    @physician = Physician.find_by(email_primary: params[:email])
    
    unless @physician
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
  
  def save_subscribe_plan_id
    session[:subscribe_plan_id] = params[:plan_id]
  end
  
  def clear_subscribe_plan_id
    session[:subscribe_plan_id] = nil
  end
  
  def physician_params
    params.require(:physician).permit(
      :firstname,
      :lastname,
      :middlename,
      :gender_id,
      :reg_num,
      :email_primary,
      :email_secondary,
      :specialization,
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
      :avatar,
      :terms_of_service,
      :subscriptions_attributes => [
                                    :plan_id
                                    ]
      )
  end
end

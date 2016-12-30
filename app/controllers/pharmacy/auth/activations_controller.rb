class Pharmacy::Auth::ActivationsController < Pharmacy::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  layout 'pharmacy/session'
  
  skip_before_action :require_active_subscription

  def new
    @pharmacy = Pharmacy.find(params[:pharmacy_id]) if params[:pharmacy_id]
  end

  def create
    if params[:activation_code].blank?
      flash[:error] = "You must provide a valid activation URL"
    else
      @pharmacy = Pharmacy.find_using_perishable_token(params[:activation_code], 1.week)
      
      unless @pharmacy.blank? || @pharmacy.active?
        if @pharmacy.activate!
          flash[:notice] = "Your account has been activated!"
          PharmacySession.create(@pharmacy, false) # Log pharmacy in manually
          PharmacyMailer.activation_welcome(@pharmacy).deliver_now
        end
      else
        flash[:error] = "That account does not exist or has already been activated"
      end
    end
    
    redirect_to pharmacy_login_url
  end
  
  def resend
    if params[:pharmacy_id]
      @pharmacy = Pharmacy.find params[:pharmacy_id]
      if @pharmacy && !@pharmacy.active?
        PharmacyMailer.activation_instructions(@pharmacy).deliver_now
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
      else
        flash[:error] = "Your account is already active!"
      end
    end
    
    redirect_to pharmacy_login_url
  end
end

class Pharmacist::Auth::ActivationsController < Pharmacist::BaseController
  before_action :require_no_auth, :only => [ :new, :create ]
  skip_before_action :require_auth

  layout 'pharmacist/session'
  
  skip_before_action :require_active_subscription

  def new
    @pharmacist = Pharmacist.find(params[:pharmacist_id]) if params[:pharmacist_id]
  end

  def create
    if params[:activation_code].blank?
      flash[:error] = "You must provide a valid activation URL"
    else
      @pharmacist = Pharmacist.find_using_perishable_token(params[:activation_code], 1.week)
      
      unless @pharmacist.blank? || @pharmacist.active?
        if @pharmacist.activate!
          flash[:notice] = "Your account has been activated!"
          PharmacistSession.create(@pharmacist, false) # Log pharmacist in manually
          PharmacistMailer.activation_welcome(@pharmacist).deliver_now
        end
      else
        flash[:error] = "That account does not exist or has already been activated"
      end
    end
    
    redirect_to pharmacist_login_url
  end
  
  def resend
    if params[:pharmacist_id]
      @pharmacist = Pharmacist.find params[:pharmacist_id]
      if @pharmacist && !@pharmacist.active?
        PharmacistMailer.activation_instructions(@pharmacist).deliver_now
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
      else
        flash[:error] = "Your account is already active!"
      end
    end
    
    redirect_to pharmacist_login_url
  end
end

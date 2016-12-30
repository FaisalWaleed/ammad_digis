class Pharmacy::BaseController < ApplicationController
  include Pundit
  
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  layout proc{ |c| c.request.xhr? ? false : "pharmacy/dashboard" }
  
  before_action :require_auth, :require_active_subscription, :require_profile
  
  helper_method :current_pharmacy, :current_pharmacy, :current_subscription
  
  def current_pharmacy_session
    return @current_pharmacy_session if defined?(@current_pharmacy_session)
    @current_pharmacy_session = PharmacySession.find
  end

  def current_pharmacy
    return @current_pharmacy if defined?(@current_pharmacy)
    @current_pharmacy = current_pharmacy_session && current_pharmacy_session.pharmacy
  end
  
  def current_subscription
    @current_subscription
  end
  
  
  def require_active_subscription
    unless current_pharmacy && current_pharmacy.active_subscription.present? && current_pharmacy.active?
      flash[:notice] = "You must purchase a plan in order to continue"
      @current_subscription = current_pharmacy.subscriptions.expired.last
      redirect_to new_pharmacy_subscription_path
    end
  end
  
  def require_profile
    if current_pharmacy
      unless current_pharmacy.profile_complete?
        flash[:notice] = "Please complete your profile in order to access your account"
        redirect_to pharmacy_profile_edit_path
      end
    end
  end
  
  def require_auth
    unless current_pharmacy
      store_location
	  respond_to do |format|
		format.html do
		  flash.now[:notice] = "Please log in to access the portal"
		  redirect_to pharmacy_login_url
		end
		
		format.js do
		  render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
		end
	  end
	  return false
    end
  end
  
  def require_no_auth
    if current_pharmacy
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
	  respond_to do |format|
		format.html do
		  redirect_to pharmacy_root_url
		end
		
		format.js do
		  render :callback => params[:callback], :json => current_pharmacy.as_json
		end
	  end
      return false
    end
  end
  
  def pundit_user
    current_pharmacy
  end
  
  def not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(pharmacy_root_path)
  end
end

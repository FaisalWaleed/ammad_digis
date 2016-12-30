class Physician::BaseController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "physician/dashboard" }
  
  before_action :require_auth#, :require_active_subscription, :require_profile
  
  helper_method :current_physician, :current_subscription
  
  def current_physician_session
    return @current_physician_session if defined?(@current_physician_session)
    @current_physician_session = PhysicianSession.find
  end

  def current_physician
    return @current_physician if defined?(@current_physician)
    @current_physician = current_physician_session && current_physician_session.physician
  end
  
  def current_subscription
    @current_subscription
  end
  
  def require_active_subscription
    unless current_physician && current_physician.active_subscription.present?
      flash[:notice] = "You must purchase a plan in order to continue"
      @current_subscription = current_physician.subscriptions.expired.last
      redirect_to new_physician_subscription_path
    end
  end
  
  def require_profile
    if current_physician
      unless current_physician.profile_complete?
        flash[:notice] = "Please complete your profile in order to access your account"
        redirect_to physician_profile_edit_path
      end
    end
  end

  def require_auth
    unless current_physician
      store_location
	  respond_to do |format|
		format.html do
		  flash.now[:notice] = "Please log in to access the portal"
		  redirect_to physician_login_url
		end
		
		format.js do
		  render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
		end
	  end
	  return false
    end
  end
  
  def require_no_auth
    if current_physician
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
	  respond_to do |format|
		format.html do
		  redirect_to physician_root_url
		end
		
		format.js do
		  render :callback => params[:callback], :json => current_physician.as_json
		end
	  end
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end

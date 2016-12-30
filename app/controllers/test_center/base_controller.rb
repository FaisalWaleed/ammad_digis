class TestCenter::BaseController < ApplicationController
  include Pundit
  
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  
  layout proc{ |c| c.request.xhr? ? false : "test_center/dashboard" }
  
  before_action :require_auth, :require_active_subscription, :require_profile
  
  helper_method :current_test_center, :current_test_center, :current_subscription
  
  def current_subscription
    @current_subscription
  end
  
  def require_active_subscription
    unless current_test_center && current_test_center.active_subscription.present?
      flash[:notice] = "You must purchase a plan in order to continue"
      @current_subscription = current_test_center.subscriptions.expired.last
      redirect_to new_test_center_subscription_path
    end
  end
  
  def current_test_center_session
    return @current_test_center_session if defined?(@current_test_center_session)
    @current_test_center_session = TestCenterSession.find
  end
  
  def current_test_center
    return @current_test_center if defined?(@current_test_center)
    @current_test_center = current_test_center_session && current_test_center_session.test_center
  end
  
  def require_profile
    if current_test_center
      unless current_test_center.profile_complete?
        flash[:notice] = "Please complete your profile in order to access your account"
        redirect_to test_center_profile_edit_path
      end
    end
  end
  
  def require_auth
    unless current_test_center
      store_location
      respond_to do |format|
        format.html do
          flash.now[:notice] = "Please log in to access the portal"
          redirect_to test_center_login_url
        end
        
        format.js do
          render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
        end
      end
      return false
    end
  end
  
  def require_no_auth
    if current_test_center
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
      respond_to do |format|
        format.html do
          redirect_to test_center_root_url
        end
        
        format.js do
          render :callback => params[:callback], :json => current_test_center.as_json
        end
      end
      return false
    end
  end
  
  def pundit_user
    current_test_center
  end
  
  def not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(test_center_root_path)
  end
end

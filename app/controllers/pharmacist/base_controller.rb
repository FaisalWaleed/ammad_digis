class Pharmacist::BaseController < ApplicationController
  include Pundit
  
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  layout proc{ |c| c.request.xhr? ? false : "pharmacist/dashboard" }
  
  before_action :require_auth #, :require_profile
  before_action :require_active_subscription
  
  helper_method :current_pharmacist, :current_pharmacy
  
  def require_active_subscription
    unless current_pharmacy && current_pharmacy.active_subscription.present?
      flash[:notice] = "You are attempting to access a pharmacy account that is currently not active."
      redirect_to pharmacist_profile_edit_url
    end
  end
  
  def check_for_pharmacies
    unless current_pharmacist.pharmacies.length.nonzero?
#       flash[:error] = "That area is inaccessbile as you have no assigned pharmacies"
      redirect_to(pharmacist_profile_edit_url)
    end
  end
  
  def current_pharmacist_session
    return @current_pharmacist_session if defined?(@current_pharmacist_session)
    @current_pharmacist_session = PharmacistSession.find
  end

  def current_pharmacist
    return @current_pharmacist if defined?(@current_pharmacist)
    @current_pharmacist = current_pharmacist_session && current_pharmacist_session.pharmacist
  end
  
  def current_pharmacy
    pid = params[:current_pharmacy].presence || session[:current_pharmacy].presence
    
    if pid
      @current_pharmacy = current_pharmacist.pharmacies.where('pharmacies.id = ?', pid).first
    else
      @current_pharmacy = current_pharmacist.pharmacies.first
    end
    
    if @current_pharmacy
      session[:current_pharmacy] = @current_pharmacy.id

      return @current_pharmacy
    else
      return nil
    end
  end
  
  def require_profile
    if current_pharmacist
      unless current_pharmacist.profile_complete?
        flash[:notice] = "Please complete your profile in order to access your account"
        redirect_to pharmacist_profile_edit_path
      end
    end
  end
  
  def require_auth
    unless current_pharmacist
      store_location
	  respond_to do |format|
		format.html do
		  flash.now[:notice] = "Please log in to access the portal"
		  redirect_to pharmacist_login_url
		end
		
		format.js do
		  render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
		end
	  end
	  return false
    end
  end
  
  def require_no_auth
    if current_pharmacist
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
	  respond_to do |format|
		format.html do
		  redirect_to pharmacist_root_url
		end
		
		format.js do
		  render :callback => params[:callback], :json => current_pharmacist.as_json
		end
	  end
      return false
    end
  end
  
  def pundit_user
    current_pharmacist
  end
  
  def not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(pharmacist_root_path)
  end
end

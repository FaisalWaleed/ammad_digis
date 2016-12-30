class Technician::BaseController < ApplicationController
  include Pundit
  
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  
  layout proc{ |c| c.request.xhr? ? false : "technician/dashboard" }
  
  before_action :require_auth #, :require_profile
  
  helper_method :current_technician, :current_laboratory
  before_action :require_active_subscription
  
  def require_active_subscription
    unless current_laboratory && current_laboratory.active_subscription.present? && current_laboratory.active?
      flash[:notice] = "You are attempting to access a test center account that is currently not active."
      redirect_to technician_profile_edit_url
    end
  end
  
  def check_for_laboratories
    unless current_technician.laboratories.length.nonzero?
      flash[:error] = "That area is inaccessbile as you have no assigned a test center"
      redirect_to(technician_profile_edit_url)
    end
  end
  
  def current_technician_session
    return @current_technician_session if defined?(@current_technician_session)
    @current_technician_session = TechnicianSession.find
  end
  
  def current_technician
    return @current_technician if defined?(@current_technician)
    @current_technician = current_technician_session && current_technician_session.technician
  end
  
  def current_laboratory
    pid = params[:current_laboratory].presence || session[:current_laboratory].presence
    
    if pid
      @laboratory = current_technician.laboratories.where('laboratories.id = ?', pid).first
    else
      @laboratory = current_technician.laboratories.first
    end
    
    if @laboratory
      session[:current_laboratory] = @laboratory.id
      
      return @laboratory
    end
  end
  
  def require_profile
    if current_technician
      unless current_technician.profile_complete?
        flash[:notice] = "Please complete your profile in order to access your account"
        redirect_to technician_profile_edit_path
      end
    end
  end
  
  def require_auth
    unless current_technician
      store_location
      respond_to do |format|
        format.html do
          flash.now[:notice] = "Please log in to access the portal"
          redirect_to technician_login_url
        end
        
        format.js do
          render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
        end
      end
      return false
    end
  end
  
  def require_no_auth
    if current_technician
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
      respond_to do |format|
        format.html do
          redirect_to technician_root_url
        end
        
        format.js do
          render :callback => params[:callback], :json => current_technician.as_json
        end
      end
      return false
    end
  end
  
  def pundit_user
    current_technician
  end
  
  def not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(technician_root_path)
  end
end

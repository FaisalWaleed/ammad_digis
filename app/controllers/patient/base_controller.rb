class Patient::BaseController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "patient/dashboard" }
  
  before_action :require_auth
  helper_method :current_patient

  def current_patient_session
    return @current_patient_session if defined?(@current_patient_session)
    @current_patient_session = PatientSession.find
  end
  
  def current_patient
    return @current_patient if defined?(@current_patient)
    @current_patient = current_patient_session && current_patient_session.patient
  end

  def require_auth
    unless current_patient
      store_location
      respond_to do |format|
        format.html do
          flash.now[:notice] = "Please log in to access the portal"
          redirect_to patient_login_url
        end
        
        format.js do
          render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
        end
      end
      return false
    end
  end

  def require_no_auth
    if current_patient
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
      respond_to do |format|
        format.html do
          redirect_to patient_login_url
        end

        format.js do
          render :callback => params[:callback], :json => current_patient.as_json
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

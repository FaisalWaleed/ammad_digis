class Admin::BaseController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "admin/dashboard" }
  
  before_action :require_auth
  
  helper_method :current_admin
  
  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end
  
  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.admin
  end
  
  def require_auth
    unless current_admin
      store_location
      respond_to do |format|
        format.html do
          flash.now[:notice] = "Please log in to access the portal"
          redirect_to admin_login_url
        end
        
        format.js do
          render :callback => params[:callback], :status => 401, :json => { :logout => 1, :message => "Your session seems to have expired. Please log in again." }.as_json
        end
      end
      return false
    end
  end
  
  def require_no_auth
    if current_admin
      store_location
      flash.now[:notice] = "Sorry, you cant access that page while logged in"
      
      respond_to do |format|
        format.html do
          redirect_to admin_root_url
        end
        
        format.js do
          render :callback => params[:callback], :json => current_admin.as_json
        end
      end
      return false
    end
  end
end

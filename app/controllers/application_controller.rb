class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)

  protect_from_forgery with: :exception
  
  before_filter :ensure_superadmin_exists!
  before_filter :setup_search
  
  before_action :set_request_variant
  
  protected
  
  def set_request_variant
    request.variant = :print if params.has_key?(:print)
  end
  
  def setup_search
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
    @term = params[:term].presence
  end
  
  def ensure_superadmin_exists!
    unless Admin.superadmins.count > 0
      excluded_controllers = %w(admins)
      excluded_actions = %w(create new)
      
      redirect_to new_admin_path unless (excluded_controllers.include?(params[:controller]) && excluded_actions.include?(params[:action]))
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

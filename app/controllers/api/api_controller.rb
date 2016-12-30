 
module Api
  class ApiController < ActionController::Base
    before_action :authenticate
    
    respond_to :json
    
    helper_method :current_physician
    
    def current_physician_session
      return @current_physician_session if defined?(@current_physician_session)
      @current_physician_session = PhysicianSession.find
    end
    
    def current_physician
      return @current_physician if defined?(@current_physician)
      @current_physician = current_physician_session && current_physician_session.physician
    end

    def authenticate
      
    end
    
  end
end
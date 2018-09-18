class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    
    helper_method :current_room
    
    private
    
    def current_room
       session[:room] 
    end
end

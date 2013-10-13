class ApplicationController < ActionController::Base
  protect_from_forgery
	
	def login_check
		if session[:user_id].nil?
			redirect_to "/sessions/login"
		end
	end
end

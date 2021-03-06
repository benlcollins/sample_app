module SessionsHelper

	# logs in the given user
	def log_in(user)
		session[:user_id] = user.id
	end

	# remembers the user in persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# get the current user
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			# raise
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# returns true if the given user is the current user
	def current_user?(user)
		user == current_user
	end

	# check if user logged in
	def logged_in?
		!current_user.nil?
	end

	# forgets a persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# log out the current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# redirects to the stored location (or to default)
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# stores the location for get request
	def store_location
		session[:forwarding_url] = request.url if request.get?
	end

end

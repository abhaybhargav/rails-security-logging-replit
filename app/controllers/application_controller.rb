class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      SecurityLogger.log_event(
        event_type: 'authentication_failure',
        message: 'Unauthorized access attempt',
        user_id: nil,
        ip_address: request.remote_ip
      )
      redirect_to login_url
    end
  end
end
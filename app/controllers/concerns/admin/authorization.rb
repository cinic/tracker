module Admin::Authorization
  extend ActiveSupport::Concern

  included do
    before_action :login_required
    helper_method :current_user, :logged_in?, :superadmin?
  end
  
  def current_user
    if session[:admin]
      @current_user ||= Admin::Admin.find(session[:admin])
    elsif cookies[:remember_token]
      @current_user ||= Admin::Admin.find_by_remember_token!(cookies[:remember_token])
    end
  end

  def superadmin?
    current_user.role == "0"
  end

  def logged_in?
    !current_user.nil?
  end

  def login_required
    unless logged_in?
      store_location
      redirect_to admin_login_url, alert: "You must first log in or sign up before accessing this page."
    end
  end

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    current_user.logout(cookies)
    current_user = nil
  end

  def session_create(user_id)
    session[:admin] = user_id
  end

  def session_destroy
    session[:admin] = nil
  end

  def redirect_back_or(default, *args)

    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  private

  def store_location
    session[:return_to] = request.url
  end

end
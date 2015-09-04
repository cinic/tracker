module Authorization
  extend ActiveSupport::Concern

  included do
    before_filter :login_required
    helper_method :current_user, :logged_in?
    after_filter :save_current_user_if_dirty, :update_last_activity_at
  end
  
  def current_user
    if session[:user]
      @current_user ||= User.find(session[:user])
    elsif cookies[:remember_token]
      @current_user ||= User.find_by_remember_token!(cookies[:remember_token])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def login_required
    unless logged_in?
      store_location
      redirect_to login_url, alert: "You must first log in or sign up before accessing this page."
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
    session[:user] = user_id
  end

  def session_destroy
    session[:user] = nil
  end

  def redirect_back_or(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  private

  def store_location
    session[:return_to] = request.url
  end

  # NB: last_activity_at is not updated on logout as we don't have current_user
  def update_last_activity_at
    current_user.last_activity_at = Time.zone.now if current_user
  end

  def save_current_user_if_dirty
    current_user.save!(:validate => false) if current_user && current_user.changed?
  end

end
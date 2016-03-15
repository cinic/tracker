class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_location
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :banned?
  before_action :set_locale

  layout :layout

  protected

  def layout
    if self.class.name.split('::').first == 'Admin'
      'admin'
    else
      'frontend'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:role, :name, :company, :address, :email, :password, :locale) }
  end

  private

  def store_location
    return unless request.get?
    return if devise_referrer
    session[:previous_url] = request.fullpath
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:notice] = t('activerecord.attributes.user.banned')
      new_user_session_path
    else
      session[:previous_url] || devices_path
    end
  end

  def banned?
    return unless current_user.present? && current_user.banned?
    sign_out current_user
    flash[:notice] = t('activerecord.attributes.user.banned')
    new_user_session_path
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    options.merge(locale: (I18n.locale == :ru ? '' : I18n.locale))
  end

  def devise_referrer
    request.path == new_user_session_path ||
      request.path == new_user_registration_path ||
      request.path == new_user_password_path ||
      request.path == edit_user_password_path ||
      request.path == user_confirmation_path ||
      request.path == new_user_confirmation_path ||
      request.path == destroy_user_session_path ||
      request.xhr?
  end
end

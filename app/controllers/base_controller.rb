class BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_locale

  layout 'frontend'

  def index; end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    options.merge(locale: (I18n.locale == :ru ? '' : I18n.locale))
  end
end

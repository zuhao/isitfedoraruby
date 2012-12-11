class ApplicationController < ActionController::Base
  protect_from_forgery

  include FastGettext::Translation
  before_filter :set_users_locale

  def set_users_locale
    I18n.locale = FastGettext.set_locale(params[:locale] || cookies[:locale] ||
      request.env['HTTP_ACCEPT_LANGUAGE'] || 'en')
    cookies[:locale] = I18n.locale if cookies[:locale] != I18n.locale.to_s
  end

end

class ApplicationController < ActionController::Base
  protect_from_forgery

  include FastGettext::Translation
  before_filter :set_gettext_locale
end

class ApplicationController < ActionController::Base
  protect_from_forgery

  include FastGettext::Translation
  before_action :set_gettext_locale

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: ->(exception) { render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController,
                ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound,
                with: ->(exception) { render_error 404, exception }
  end

  private

  def render_error(status, _exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
end

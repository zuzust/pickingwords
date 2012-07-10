class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    # render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
    redirect_to root_url, alert: exception.message
  end

  private

  def current_ability
    @current_ability ||= admin_signed_in? ? Ability.new(current_admin) : Ability.new(current_user)
  end
end

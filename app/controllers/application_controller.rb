class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?

  helper_method :logged_in?, :curr_user, :curr_user_roles

  def logged_in?
    @logged_in ||= (signed_in?(:user) || signed_in?(:admin))
  end

  def curr_user
    @curr_user ||= (current_user || current_admin)
  end

  def curr_user_roles
    session[:curr_user_roles] ||= curr_user.roles.map(&:name)
  end

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    # render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
    redirect_to root_url, alert: exception.message
  end

  private

  def current_ability
    @current_ability ||= Ability.new(curr_user, curr_user_roles)
  end
end

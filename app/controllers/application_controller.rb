class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?

  helper_method :logged_in?, :user, :user_roles

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    # render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
    redirect_to root_url, alert: exception.message
  end

protected

  def logged_in?
    @logged_in ||= (signed_in?(:user) || signed_in?(:admin))
  end

  def user
    @user ||= (current_user || current_admin)
  end

  def user_roles
    session[:user_roles] ||= user.roles.map(&:name)
  end

  def store_in_session(entries)
    entries.each do |name, value|
      session[name] = value
    end
  end

  def store_in_cache(resources)
    resources.each do |key, resource|
      Rails.cache.write(key, resource, expires_in: 1.hour)
    end
  end

  def stored_in_cache?(key)
    Rails.cache.exist? key
  end

  def load_from_cache(key)
    if block_given?
      Rails.cache.fetch(key, expires_in: 1.hour) { yield }
    else
      Rails.cache.fetch(key, expires_in: 1.hour)
    end
  end

  def expire_from_cache(key)
    cache = Rails.cache
    cache.delete(key) if cache.exist?(key)
  end

private

  def current_ability
    @current_ability ||= Ability.new(user, user_roles)
  end
end

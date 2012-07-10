class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    # redirect_to root_url, alert: exception.message
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end

  protected

  # See:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in-out
  # http://rubydoc.info/github/plataformatec/devise/master/Devise/Controllers/Helpers#after_sign_in_path_for-instance_method
  def after_sign_in_path_for(user)
    user.has_role?(:admin) ? tracked_words_path : user_picked_words_path(user)
  end
end

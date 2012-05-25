class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  protected

  # See:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in-out
  # http://rubydoc.info/github/plataformatec/devise/master/Devise/Controllers/Helpers#after_sign_in_path_for-instance_method
  def after_sign_in_path_for(user)
    user_picked_words_path(user)
  end
end

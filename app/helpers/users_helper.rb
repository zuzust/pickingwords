module UsersHelper

  # Authentication & Authorization
  # -------------------------------------
  def logged_in?
    @logged_in ||= (signed_in?(:user) || signed_in?(:admin))
  end

  def curr_user
    @curr_user ||= (current_user || current_admin)
  end
  
  def curr_user_roles
    session[:curr_user_roles] ||= curr_user.roles.map(&:name)
  end

end

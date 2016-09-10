module ActAsUser

  def current_role_user
    @current_role_user ||=
      (current_user.admin? && session[:role_user_id]) ? User.find(session[:role_user_id]) : current_user
  end
end

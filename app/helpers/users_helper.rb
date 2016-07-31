module UsersHelper

  def avatar_url(user, version=:mini)
    user.avatar.file ? user.avatar.url(version) : 'missing.png'
  end

  def dancers_collection
    User.dancer_with_profile.order(:email).collect {|p| [ p.email, p.id ] }
  end
end

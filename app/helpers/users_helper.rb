module UsersHelper

  def avatar_url(user, version=:mini)
    user.avatar.file ? user.avatar.url(version) : 'missing.png'
  end
end

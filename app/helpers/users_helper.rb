module UsersHelper

  def avatar_url(user, version=:mini)
    user.avatar.file ? user.avatar.url(version) : 'missing.png'
  end

  def dancers_collection
    dancers = User.dancer.joins(:profile).group('users.id').having('count(user_id) > 0')
    dancers.to_a.sort! { |x, y| x.perform_name.downcase <=> y.perform_name.downcase }
    dancers.collect {|p| [ p.perform_name, p.id ] }
  end
end

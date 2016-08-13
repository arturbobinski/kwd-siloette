module UsersHelper

  def avatar_url(user, version=:mini)
    user.avatar.file ? user.avatar.url(version) : 'missing.png'
  end

  def dancers_collection
    User.dancer_with_profile.order(:email).collect {|p| [ p.email, p.id ] }
  end

  def country_code_collection
    Rails.cache.fetch('siloette.country_codes', expires_in: 1.day) do
      Country.order(:name).pluck(:name, :dial_code).map { |x| ["#{x[0]}(#{x[1]})", x[1]] }
    end
  end

  def country_code_value(obj)
    obj.country_code.blank? ? Country.find_by(iso: cookies[:country]).try(:dial_code) : obj.country_code
  end
end

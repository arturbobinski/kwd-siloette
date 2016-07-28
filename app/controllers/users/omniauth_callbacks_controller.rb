class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def callback(provider)
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)

    if @user.persisted?
      original_params = request.env['omniauth.params']
      if !original_params.blank? && original_params['state'] == 'dancer'
        @user.dancer!
      end

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s.humanize) if is_navigational_format?
    else
      session['devise.omauth_data'] = auth
      redirect_to new_user_registration_url
    end
  end

  def facebook
    callback(:facebook)
  end

  def instagram
    callback(:instagram)
  end

  def google_oauth2
    callback(:google_oauth2)
  end

  def twitter
    callback(:twitter)
  end

  def failure
    redirect_to root_path
  end
end
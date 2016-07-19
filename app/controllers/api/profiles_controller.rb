module Api
  class ProfilesController < Api::BaseController

    def check_perform_name
      profile = Profile.where('LOWER(perform_name) = ?', params[:user][:profile_attributes][:perform_name].downcase).first
      if profile && profile.user != current_user
        render nothing: true, status: 422
      else
        render nothing: true, status: 200
      end
    end
  end
end
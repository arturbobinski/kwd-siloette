module Api
  class UsersController < Api::BaseController

    def check_email
      user = User.find_by(email: params[:user][:email])
      if user && user != current_user
        render nothing: true, status: 422
      else
        render nothing: true, status: 200
      end
    end

    def check_slug
      user = User.find_by(slug: params[:user][:slug])
      if user && user != current_user
        render nothing: true, status: 422
      else
        render nothing: true, status: 200
      end
    end

    def set_time_zone
      cookies[:time_zone] = params[:time_zone] unless ActiveSupport::TimeZone[params[:time_zone]].nil?
      render nothing: true
    end
  end
end
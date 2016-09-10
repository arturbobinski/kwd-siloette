module Api
  class UsersController < Api::BaseController

    def check_email
      user = User.find_by(email: params[:user][:email])
      if user && user != current_role_user
        render nothing: true, status: 404
      else
        render nothing: true, status: 200
      end
    end

    def check_slug
      user = User.find_by(slug: params[:user][:slug])
      if user && user != current_role_user
        render nothing: true, status: 404
      else
        render nothing: true, status: 200
      end
    end
  end
end
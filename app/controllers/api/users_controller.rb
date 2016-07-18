module Api
  class UsersController < Api::BaseController

    def check_email
      if user = User.find_by(email: params[:user][:email])
        render nothing: true, status: 422
      else
        render nothing: true, status: 200
      end
    end
  end
end
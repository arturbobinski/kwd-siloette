module Api
  class BaseController < ActionController::Base

    include ActAsUser

  end
end
module System
  class BaseController < ApplicationController

    load_and_authorize_resource
  end
end
module Api
  class StatesController < Api::BaseController

    def index
      @states = State.where(country_id: params[:country_id]).order(:name).select(:id, :name)
      render json: @states, status: 200
    end
  end
end
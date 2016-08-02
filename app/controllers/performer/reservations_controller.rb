module Performer
  class ReservationsController < Performer::BaseController

    skip_before_action :verify_authenticity_token, only: [:destroy]

    def create
      redirect_to :back, alert: t('.choose_slots') and return unless params[:slots].present?

      params[:slots].each do |slot|
        current_user.reservations.create(start_at: user_time_zone.parse(params[:date]) + slot.to_i.hour)
      end
    
      redirect_to :back, notice: t('.notice')
    end

    def destroy
      @reservation.destroy
    end
  end
end
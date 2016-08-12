module Performer
  class DailySchedulesController < Performer::BaseController

    def index
      if (current_user.schedules.order(:wday)).blank?
        (0..6).each { |i| current_user.schedules.build(wday: i, start_slot: 8, end_slot: 20) }
      end
    end

    def set_schedule
      @user = current_user

      if @user.update(user_params)
        redirect_to calendar_performer_bookings_path, notice: t('.notice')
      else
        redirect_to :back, alert: t('.alert')
      end
    end

    private

    def user_params
      params.require(:user).permit(schedules_attributes: [:id, :wday, :start_slot, :end_slot, :active])
    end
  end
end
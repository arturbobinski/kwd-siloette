module System
  class ServiceInvitationsController < System::BaseController

    skip_load_and_authorize_resource only: [:accept, :decline, :destroy]
    before_filter :load_service_invitation

    def accept
      @service_inviataion.accepted!
      redirect_to :back
    end

    def decline
      @service_inviataion.declined!
      redirect_to :back
    end

    def destroy
      @service_inviataion.destroy
      redirect_to :back
    end

    private

    def load_service_invitation
      @service_inviataion = current_user.invitations.find_by(service_id: params[:id])
    end
  end
end
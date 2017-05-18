module Performer
  class ServicesController < Performer::BaseController

    before_filter :get_image_ids, only: [:create]
    before_filter :check_profile, :build_association, only: [:new, :edit]

    def index
      params[:scope] ||= 'personal'

      if params[:scope] == 'personal'
        @services = current_user.services
      else
        @services = current_user.send("#{params[:scope]}_services")
      end

      @services = @services.recent.includes(:category, :primary_image, performers: :profile)
    end

    def new
    end

    def create
      @service = current_user.services.new(service_params)
      @service.open = false

      if @service.save
        @service.image_ids = @image_ids
        UserMailer.new_service_created(current_user).deliver
        UserMailer.new_service_created_admin(User.where(role: 3).first).deliver
        accept_invitation
        redirect_to performer_services_path(scope: 'personal'), notice: t('.notice')
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @service.update(service_params)
        accept_invitation
        if path = next_path
          redirect_to path
        else
          redirect_to :back, notice: t('.notice')
        end
      else
        render :edit
      end
    end

    def destory
      @service.destory
      redirect_to performer_services_path, notice: t('.notice')
    end

    def close
      @service.update open: false
      redirect_to :back, notice: t('.notice')
    end

    def open
      @service.update open: true
      redirect_to :back, notice: t('.notice')
    end

    private

    def service_params
      params.require(:service).permit(
        :category_id, :description, :price, :status, :location_id, invitee_ids: [],
        images_attributes: (action_name == 'create' ? [] : [:id, :_destroy]),
        video_attributes: [:id, :link]
      )
    end

    def check_profile
      if current_user.dancer? && !current_user.profile_ready?
        flash[:warning] = t('common.update_profile_first')
        redirect_to edit_user_path(current_user) and return
      end
    end

    def build_association
      build_location
      build_images
      build_video
    end

    def build_location
      @service.build_location unless @service.location
    end

    def accept_invitation
      @invitation = @service.invitations.find_by(user: current_user)
      @invitation.accepted! if @invitation
    end

    def build_images
      images_count = @service.images.count
      (3 - images_count).times { @service.images.build } if images_count < 3
    end

    def build_video
      @service.build_video unless @service.video
    end

    def get_image_ids
      @image_ids = []
      params[:service][:images_attributes].values.each { |x| @image_ids << x[:id] if x[:_destroy] == 'false' }
    end
  end
end
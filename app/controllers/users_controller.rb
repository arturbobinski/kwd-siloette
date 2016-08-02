class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource

  def show
    if @user.dancer?
      @profile = @user.profile
      @services = @user.performing_services.active.open.recent.includes(:category, :primary_image, performers: :profile).limit(6)
    end
  end

  def edit
    if @user.dancer?
      @user.build_profile if @user.profile.nil?
      @user.build_location if @user.location.nil?
    end
  end

  def update
    if @user.update(user_params)
      redirect_to (@user.dancer? && !@user.services.any? ? new_performer_service_path : edit_user_path(@user)), notice: t('.notice')
    else
      render :edit
    end
  end

  def become_dancer
    @user.dancer!
    redirect_to edit_user_path(current_user)
  end

  def media
  end

  def stripe_account
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :slug, :gender, :description, :birth_date, :avatar, :avatar_cache,
      profile_attributes: [:id, :perform_name, :height, :body_type, :ethnicity, :phone_number, :experience_level,
        :social_security_number, :education_level, language_ids: []],
      location_attributes: [:id, :address, :country, :postal_code, :lat, :lng],
      service_images_attributes: [:id, :profile]
    )
  end
end

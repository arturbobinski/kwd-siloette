class UsersController < ApplicationController

  skip_before_action :check_verified, only: [:apply, :update]
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource

  def show
    if @user.dancer?
      @profile = @user.profile
      @services = @user.performing_services.active.open.recent.includes(:category, :primary_image, performers: :profile).limit(6)
    end
  end

  def edit
    build_resources
  end

  def update
    if @user.update(user_params)
      if !@user.verified?
        UserMailer.user_verification_email(@user).deliver_later
        redirect_to :back, notice: t('.profile_reviewing')
      else
        redirect_to (@user.dancer? && !@user.services.any? ? new_performer_service_path : edit_user_path(@user)), notice: t('.notice')
      end
    else
      if !@user.verified?
        render 'users/apply'
      else
        render :edit
      end
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

  def apply
    build_resources
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :slug, :gender, :description, :birth_date, :avatar, :avatar_cache, :referred_by,
      profile_attributes: [:id, :perform_name, :height, :body_type, :ethnicity, :phone_number, :experience_level,
        :social_security_number, :education_level, :eligible_in_us, :hear_from, :communing_plan,
        language_ids: [], experience_ids: []],
      location_attributes: [:id, :address, :country, :postal_code, :lat, :lng],
      service_images_attributes: [:id, :profile]
    )
  end

  def build_resources
    if @user.dancer?
      @user.build_profile if @user.profile.nil?
      @user.build_location if @user.location.nil?
    end
  end
end

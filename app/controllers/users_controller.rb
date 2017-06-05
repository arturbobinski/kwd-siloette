class UsersController < ApplicationController

  #skip_before_action :check_verified, only: [:apply, :update]
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource

  def show
    if @user.dancer?
      @profile = @user.profile
      @services = @user.performing_services.active.open.recent.includes(:category, :primary_image, performers: :profile).limit(6)
      @testimonials = @user.received_feedbacks
    end
  end

  def edit
    session[:role_user_id] = params[:id] if current_user.admin? && params[:is_admin].present?
    build_resources
  end

 #def update
 #   if @user.update(user_params)
#      if @user.dancer? 
#        redirect_to edit_user_path(@user), notice: t('.notice')
#      end
#    else
#      if @user.dancer?
#        # format.html { render :edit }
#      end
#    end
#  end

  def update
    if @user.update(user_params)
      if @user.dancer?
        UserMailer.user_verification_email(@user).deliver_later
        UserMailer.user_verifying_email(@user).deliver_later
        redirect_to :back
      elsif path = next_path(@user)
        redirect_to path
      else
        redirect_to edit_user_path(@user), notice: t('.notice')
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
      :first_name, :last_name, :email, :slug, :description, :birth_date, :avatar, :avatar_cache,
      :referred_by, :instagram_handle,
      profile_attributes: [:id, :perform_name, :height, :body_type, :ethnicity, :phone_number, :experience_level,
        :social_security_number, :education_level, :country_code,
        language_ids: [], experience_ids: []],
      location_attributes: [:address, :country, :postal_code, :lat, :lng],
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

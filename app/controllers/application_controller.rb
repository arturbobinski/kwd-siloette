class ApplicationController < ActionController::Base

  http_basic_authenticate_with name: Figaro.env.http_user, password: Figaro.env.http_password if Rails.env.staging?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_verified, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :load_pages

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    if !(referer = stored_location_for(resource)).blank?
      referer
    elsif resource.admin?
      admin_dashboard_path
    elsif resource.dancer? && !resource.profile_ready?
      edit_user_path(resource)
    elsif request.referer == new_user_session_url
      super
    else
      root_path
    end
  end

  def user_time_zone
    @user_time_zone ||= ActiveSupport::TimeZone[cookies[:time_zone] || 'Eastern Time (US & Canada)']
  end
  helper_method :user_time_zone

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :accept_terms])
  end

  private

  def check_verified
    if current_user && !current_user.verified?
      redirect_to apply_user_path(current_user) and return
    end
  end

  def load_pages
    return if request.path =~ /admin/
    @pages = Page.order(:id).active.general
  end

  def authenticate_admin_user!
    unless current_user && current_user.admin?
      flash[:error] = t('common.admin_required')
      redirect_to new_user_session_path(role: :admin)
    end
  end

  def get_start_at
    now = user_time_zone.now

    if params[:date].present?
      @start_at = user_time_zone.parse(params[:date])
      @start_at = now if @start_at < now
    else
      @start_at = now
    end

    @start_at += 2.hours if action_name != 'calendar'
  end
end

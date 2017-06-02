class ApplicationController < ActionController::Base

  include ActAsUser

  # http_basic_authenticate_with name: Figaro.env.http_user, password: Figaro.env.http_password if Rails.env.staging?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_verified, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :detect_browser, :set_time_zone
  before_filter :load_pages

  helper_method :current_role_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      edit_user_path(current_role_user)
    end
  end

  def user_time_zone
    @user_time_zone ||= ActiveSupport::TimeZone[@current_time_zone]
  end
  helper_method :user_time_zone

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :accept_terms])
  end

  private

  def load_categories
    @categories = Category.female.select(:id, :name)
  end

  def check_verified
    return true # Remove this line to allow dancer application
    if current_user && current_user.dancer? && !current_user.verified?
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

  def detect_browser
    case request.user_agent
      when /iPad/i
        request.variant = :tablet
      when /iPhone/i
        request.variant = :phone
      when /Android/i && /mobile/i
        request.variant = :phone
      when /Android/i
        request.variant = :tablet
      when /Windows Phone/i
        request.variant = :phone
      else
        request.variant = :desktop
    end
  end

  def set_time_zone
    @current_time_zone = cookies[:time_zone] || current_user.try(:time_zone) || 'Eastern Time (US & Canada)'
    if current_user && current_user.time_zone != @current_time_zone
      current_user.update(time_zone: @current_time_zone)
    end
  end

  def next_path(user=current_user)
    # return unless user.dancer?

    if !user.profile_ready?
      edit_user_path(user)
    elsif !user.services.any?
      new_performer_service_path
    elsif !user.payment_ready?
      flash[:alert] = t('common.payment_not_ready')
      stripe_account_user_path(user)
    elsif !user.schedules.any?
      flash[:alert] = t('common.no_daily_schedule')
      performer_daily_schedules_path
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

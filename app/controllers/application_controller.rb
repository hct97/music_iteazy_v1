class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale, :set_search
  before_action :notifications, if: :user_signed_in?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_search
    @q = Song.ransack(params[:q])
  end

  def notifications
    @notifications = current_user.notifications.ordered
    @unread = @notifications.unread
  end

  private

  def logged_in_user
    return if user_signed_in?
    store_location
    flash[:danger] = t ".require_login"
    redirect_to login_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
  end
end

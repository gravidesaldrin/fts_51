class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  layout :admin

  def redirect_back_or default
    redirect_to session[:return_to] || default
    session.delete :return_to
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private
  def admin
    "application"
    if user_signed_in? && current_user.admin?
      "admin"
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :role, :avatar]
    devise_parameter_sanitizer.for(:account_update) << [:name, :avatar]
  end
end

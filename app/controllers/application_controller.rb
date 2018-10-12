class ApplicationController < ActionController::Base
  before_action :set_locale
  include SessionsHelper

  private

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "r_login"
    redirect_to login_url
  end
end

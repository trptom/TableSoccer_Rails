# coding:utf-8
include ApplicationHelper

class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def not_authenticated
    if !current_user
      redirect_to "/users/login", notice: I18n.t("messages.application.login") # TODO need login url
    else
      redirect_back_or_to("/", :notice => I18n.t('messages.application.unauthorized'))
    end
  end
  
  def require_admin
    if current_user
      if !current_user.is_admin
        redirect_to "/", :notice => I18n.t('messages.application.unauthorized')
      end
    else
      session[:return_to_url] = request.url if Config.save_return_to_url
      self.send(Config.not_authenticated_action)
    end
  end
end

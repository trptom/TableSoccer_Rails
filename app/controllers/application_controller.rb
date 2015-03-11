# coding:utf-8

include ApplicationHelper

# Basic controller for whole application. All other controllers derive from it.
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  # Filters controlled depending on condition. When condition id false, behaves
  # as before_filter (redirects to unauthorized).
  #
  # ==== Params
  # _condition_:: condition of filter. When true, controller can go on, when
  #  false, action is redirected to _root_path_ with unauthorized message.
  # _allow_admin_:: when true and _current_user_ is admin (means first account
  # created, not user with admin rights), action is always allowed (like when
  # condition is true). True by default.
  private
  def filter(condition, allow_admin = true)
    if (allow_admin && current_user.username.downcase == "admin")
      return
    end
    
    if !condition
      redirect_to root_path, :notice => I18n.t('messages.application.unauthorized')
    end
  end
  
  # TODO documentation
  private
  def not_authenticated
    if !current_user
      redirect_to "/users/login", notice: I18n.t("messages.application.login") # TODO need login url
    else
      redirect_back_or_to(root_path, :notice => I18n.t('messages.application.unauthorized'))
    end
  end
  

  # Serves as _before_filter_.<br />
  # When user is not logged in, simulates behaviour of _require_login_ filter.
  # When user is not admin (user with admin permissions) but is logged in,
  # behaves as _filter_ function with _condition_ = false.
  #
  # ==== See
  # ApplicationController#filter  
  private
  def require_admin
    if current_user
      if !current_user.is_admin
        redirect_to root_path, :notice => I18n.t('messages.application.unauthorized')
      end
    else
      session[:return_to_url] = request.url if Config.save_return_to_url
      self.send(Config.not_authenticated_action)
    end
  end
  
  # Behaves similar way like _filter_ function, but _current_user_ is used as
  # _condition_.
  #
  # ==== See
  # ApplicationController#filter
  private
  def require_not_logged
    if current_user
      redirect_to root_path, :notice => I18n.t('messages.application.unauthorized')
    end
  end
end

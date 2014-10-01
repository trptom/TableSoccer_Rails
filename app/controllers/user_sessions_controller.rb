# coding:utf-8
class UserSessionsController < ApplicationController
  before_filter :require_login, only: [:destroy]
  
#  skip_before_filter :check_permissions, :except => [:destroy]
  def create
    respond_to do |format|
	  Rails.logger.info "un: " + params[:username]
	  Rails.logger.info "ps: " + params[:password]
      if @user = login(params[:username],params[:password])
        format.html {
          redirect_back_or_to("/", :notice => I18n.t("messages.user_sessions.create.succesfull"))
        }
      else
        format.html {
          redirect_back_or_to("/", :notice => I18n.t('messages.user_sessions.create.failed'))
        }
      end
    end
  end

  def destroy
    logout
    redirect_back_or_to("/", :notice => I18n.t('messages.user_sessions.destroy.succesfull'))
  end
end

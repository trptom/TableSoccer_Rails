include ApplicationHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :log_page_request
  
  private
  def not_authenticated
    redirect_to login_url, notice: "messages.application.login"
  end
end

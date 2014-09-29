include ApplicationHelper
include PermissionsHelper

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :log_page_request
  before_filter :check_permissions
end

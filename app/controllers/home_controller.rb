class HomeController < ApplicationController
  skip_before_filter :check_permissions

  # Main action of whole application - HomePage.
  # 
  # ==== Format
  # * HTML
  # (accepts also another formats, but has no view for them)
  def index
  end
end

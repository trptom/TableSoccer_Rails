class HomeController < ApplicationController
  skip_before_filter :check_permissions

  def index
  end
end

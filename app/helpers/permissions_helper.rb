# coding:utf-8

module PermissionsHelper
  def check_permissions
    if !(access_enabled params[:controller], params[:action], params)
#        respond_to do |format|
#          format.html {
#            layout nil
#            render :file => "#{Rails.root}/public/404_minimized.html", :status => :not_found
#          }
#          format.any  { head :not_found }
#        end
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def access_enabled(ctrl, action, options)
    if ctrl == "users" && action == "edit"
      log_message LOGGER[:dev_notes], :debug,
        "checking access to users#edit, options[id]: #{options[:id]}, " +
        "current_user: #{current_user.id}, #{current_user && true}, " +
        "#{current_user.id == options[:id].to_i}, #{current_user.username == "admin"}"
      return (current_user && true) &&
        (current_user.id == options[:id].to_i || current_user.username == "admin")
    end

    log_message LOGGER[:dev_notes], :debug, "checking overall access, current_user: #{current_user}"

    # v ostatnich pripadech se chovam jako require_login
    return current_user && true;
  end
end

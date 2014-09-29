LOGGER = {
  :page_requests => Logger.new(Rails.root.join("log", Rails.env + "_page_requests.log")),
  :dev_notes => Logger.new(Rails.root.join("log", Rails.env + "_dev_notes.log"))
}

def get_log_prefix
  return current_user ?
     (l DateTime.now, :format => :logger) + " (" + current_user.username + "@" + request.remote_ip + "): " :
     (l DateTime.now, :format => :logger) + " (" + request.remote_ip + "): "
end

def get_current_url
  return "#{request.method} #{request.protocol}#{request.host_with_port}#{request.fullpath}"
end

def log_message(logger, type, message)
  message = get_log_prefix + message
  case type
  when :debug
    logger.debug message
  when :info
    logger.info message
  when :fatal
    logger.fatal message
  end
end

def log_page_request
  log_message LOGGER[:page_requests], :info, "\"#{get_current_url}\" (params: #{params})"
end
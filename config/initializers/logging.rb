# PG logs lot of rubbish so I want to avoid it in TST/DEV environment
if Rails.env.development? || Rails.env.test?
  ActiveRecord::Base.logger.level = 1
end

if Rails.env.test?
  Rails.logger.level = 2
end

def get_log_prefix
  return current_user ?
     (l DateTime.now, :format => :logger) + " (" + current_user.username + "@" + request.remote_ip + "): " :
     (l DateTime.now, :format => :logger) + " (" + request.remote_ip + "): "
end

def get_current_url
  return "#{request.method} #{request.protocol}#{request.host_with_port}#{request.fullpath}"
end

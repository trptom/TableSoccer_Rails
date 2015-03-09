desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts "Checking attendance and sending reminders..."
  # TODO some action
  # User.send_reminders
  puts "Checking of attendance done."
end
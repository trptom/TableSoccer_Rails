desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts "Checking attendance and sending reminders..."
  UserMailer.reminder_email.deliver
  puts "Checking of attendance done."
end
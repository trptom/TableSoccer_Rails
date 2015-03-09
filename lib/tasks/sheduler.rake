desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts "Checking attendance and sending reminders..."
  
  @url = WEB_URL
  @users = User.with_reminder
  @current_date = DateTime.now
  @cache = {}

  puts "Users to be checked: #{@users.count}"
  puts "Current date: #{@current_date.to_s}"
  for user in @users
    team = user.player.team

    # check if player has team (we are sure that user has player - see
    # with_reminder, but not about team)
    if team != nil
      puts "Checking user #{user.username}"

      # check all future matches of team
      for match in Match.by_team(team).future(@current_date)
        diff = (match.start_date - @current_date).to_i / (24 * 60 * 60)
        puts "Checking match #{match.to_s}, start is #{match.start_date} diff is #{diff}"

        # when date is in range for reminder, check attendance
        if (diff <= user.attendance_reminder && diff > 0)
          puts "Diff #{diff} <= #{user.attendance_reminder}, match will be checked"

          # read cache or create new ones, if not created yet
          if @cache[match] == nil
            @cache[match] = {}
          end
          if @cache[match][team] == nil
            @cache[match][team] = match.get_players_attendance(team)
          end
          attendance = @cache[match][team]

          # check attendance and possibly send email
          if (attendance[:yes].include?(user.player))
            puts "Attendance already filled, skipping"
          elsif (attendance[:no].include?(user.player))
            puts "Attendance no filled, skipping, mailing to #{user.username}"
            UserMailer.reminder_email(user, match, diff).deliver
          else
            puts "ERROR - don't know what to do?"
          end
        end
      end
    end
  end
  
  puts "Checking of attendance done."
end
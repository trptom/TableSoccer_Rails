desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  puts "Checking attendance and sending reminders..."
  
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
        diff = (match.start_date.to_date - @current_date.to_date).to_i
        puts "Checking match #{match.title}, start is #{match.start_date} diff is #{diff}"

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
    else
      puts "User #{user.username} has not team!"
    end
  end
  
  puts "Checking of attendance done."
end

task :send_attendance_overview => :environment do
  puts "Checking and sending attendance overview..."
  
  @users = User.with_attendance_overview
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
        diff = (match.start_date.to_date - @current_date.to_date).to_i
        puts "Checking match #{match.title}, start is #{match.start_date} diff is #{diff}"

        # when date is in range for reminder, check attendance
        if (diff == user.attendance_overview)
          puts "Diff #{diff} == #{user.attendance_overview}, overview will be sent"

          # read cache or create new ones, if not created yet
          if @cache[match] == nil
            @cache[match] = {}
          end
          if @cache[match][team] == nil
            @cache[match][team] = match.get_players_attendance(team)
          end
          attendance = @cache[match][team]

          yes_names = []
          attendance[:yes].each do |item|
            yes_names << item.nick_or_name
          end
          yes_str = yes_names.length == 0 ? I18n.t("messages.base.nobody") : yes_names.join(", ")
          
          no_names = []
          attendance[:no].each do |item|
            no_names << item.nick_or_name
          end
          no_str = no_names.length == 0 ? I18n.t("messages.base.nobody") : no_names.join(", ")
          
          puts "Sending mail to #{user.username} with:"
          puts "  yes: #{yes_str}"
          puts "  no: #{no_str}"
          UserMailer.attendance_overview_email(user, match, @current_date, diff, yes_str, no_str).deliver
        else
          puts "Diff #{diff} != #{user.attendance_overview}, overview will not be sent"
        end
      end
    else
      puts "User #{user.username} has not team!"
    end
  end
  
  puts "Checking and sending of attendance overview done."
end
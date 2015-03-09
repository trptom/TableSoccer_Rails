# coding:utf-8

class UserMailer < ActionMailer::Base
  default from: MAILER_ADDRESS

  def activation_needed_email(user)
    @user = user
    @url = WEB_URL
    @url_activation  = "#{WEB_URL}/users/#{user.activation_token}/activate?src=email"
    mail(:to => user.email,
         :subject => I18n.t("messages.mailers.user_mailer.welcome", :url => WEB_URL))
  end

  def activation_success_email(user)
    @user = user
    @url = WEB_URL
    mail(:to => user.email,
         :subject => I18n.t("messages.mailers.user_mailer.account_activated"))
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    @url = WEB_URL
    @url_reset  = edit_password_reset_url(user.reset_password_token, :host => WEB_URL)
    mail(:to => user.email,
         :subject => I18n.t("messages.mailers.user_mailer.password_updated"))
  end
  
  def reminder_email
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
              @match = match
              @left = diff
              mail(:to => user.email,
                   :subject => I18n.t("messages.mailers.user_mailer.attendance_reminder",
                     :team1 => match.team_home.name, :team2 => match.team_home.name))
            else
              puts "ERROR - don't know what to do?"
            end
          end
        end
      end
    end
  end
end

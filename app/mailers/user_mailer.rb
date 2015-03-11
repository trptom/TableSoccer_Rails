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
  
  def reminder_email(user, match, diff)
    @user = user
    @match = match
    @url = WEB_URL
    @left = diff
    mail(:to => user.email,
         :subject => I18n.t("messages.mailers.user_mailer.attendance_reminder",
           :team1 => match.team_home.name, :team2 => match.team_away.name))
  end
end

class ApplicationMailer < ActionMailer::Base
  default from: %("SaladaApp" <#{ENV['notifications_mailer_username']}>)
end

class ReminderMailer < Mailer
  unloadable

  def send_notification(reminder, recipients, issues)
    subject reminder.query.name
    recipients recipients

    body :reminder => reminder,
         :recipients => recipients,
         :issues => issues

    render_multipart('send_notification', body)
  end

end

class ReminderMailer < Mailer
  unloadable

  def send_notification(reminder, mailAddress, issues)
    subject reminder.query.name
    recipients mailAddress

    body :reminder => reminder,
         :recipients => mailAddress,
         :issues => issues

    render_multipart('send_notification', body)
  end

end

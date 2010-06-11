puts "Executing all reminders' notification"
reminders = Reminder.find(:all)
reminders.each do |reminder|
  puts "Sending out notification for '#{reminder.query.name}'"
  reminder.notify_all
end
puts "Done"
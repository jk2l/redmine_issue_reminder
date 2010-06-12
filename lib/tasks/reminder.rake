namespace :reminder do
  namespace :send do
    desc "Send emails to all"
    task :all_reminders => :environment do
      User.current = User.find(1)
      puts "Executing all reminders' notification"
      reminders = Reminder.find(:all)
      reminders.each do |reminder|
        puts "Sending out notification for '#{reminder.query.name}'"
        reminder.notify_all
      end
      puts "Done"
    end
  end
end

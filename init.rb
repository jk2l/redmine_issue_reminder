require 'redmine'

Redmine::Plugin.register :redmine_issue_reminder do
  name 'Redmine Issue Reminder plugin'
  author 'Jacky Leung'
  description 'A plugin that can manage reminder emailer base on query'
  version '0.0.1'

  project_module :reminders do
    permission :index, :reminders => :index
    permission :show_reminder, :reminders => :show
    permission :new_reminder, :reminders => :new
    permission :create_reminder, :reminders => :create
    permission :edit_reminder, :reminders => :edit
    permission :update_reminder, :reminders => :update
    permission :send_notification, :reminders => :notify
    permission :delete_reminder, :reminders => :destroy
  end

  menu :project_menu, :reminders, { :controller => 'reminders', :action => 'index' }, :caption => 'Issue Reminder', :after => :new_issue, :param => :project_id
end

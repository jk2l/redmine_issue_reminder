class Reminder < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :query, :class_name => 'Query', :foreign_key => 'query_id', :dependent => :destroy

  validates_presence_of :message

  def notify_all
    mail_list = query.issues(include => [:assigned_to]).group_by(&:assigned_to)
    mail_list.each do |assignee, issues|

      # TODO: Remove assignee.nil and replace with proper handling
      ReminderMailer.deliver_send_notification(self, assignee.mail, issues) unless assignee.nil?
    end
  end
end

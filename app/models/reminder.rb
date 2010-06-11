class Reminder < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :query, :class_name => 'Query', :foreign_key => 'query_id', :dependent => :destroy

  validates_presence_of :message

  def notify_all
    # TODO: Remove condition
    list = query.issues(:include => [:assigned_to], :conditions => ["assigned_to_id != 0"])

    users = {}
    list.each do |issue|
      if issue.assigned_to == nil
        # TODO: Replace this with proper handling
        next
      end

      users[issue.assigned_to] = [] if users[issue.assigned_to] == nil
      users[issue.assigned_to] << issue
    end

    mails = []
    users.each do |user, issues|
      ReminderMailer.deliver_send_notification(self, user.mail, issues)
      mails << user.mail
    end
    return mails
  end
end

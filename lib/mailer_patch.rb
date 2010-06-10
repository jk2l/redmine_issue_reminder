require_dependency 'mailer'

module MailerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable
    end

  end

  module ClassMethods

  end

  module InstanceMethods
    def send_notification(reminder, recipient, issues)
      recipients recipient
      body :issues => issues
      render_multipart('send_notification', body)
    end
  end
end

class Reminder < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :query, :class_name => 'Query', :foreign_key => 'query_id', :dependent => :destroy

  validates_presence_of :message
end

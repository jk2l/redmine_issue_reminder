class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.column :query_id, :integer, :default => 0, :null => false
      t.column :author_id, :integer, :default => 0, :null => false
      t.column :message, :string
    end
  end

  def self.down
    drop_table :reminders
  end
end

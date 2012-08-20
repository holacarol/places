class AddNotificationCode < ActiveRecord::Migration
  def up
    change_table :notifications do |t|
      t.string :notification_code, :default => nil
    end
  end

  def down
    change_table :notifications do |t|
      t.remove :notification_code
    end
  end
end
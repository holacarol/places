class AddChatEnabledColumnToUser < ActiveRecord::Migration
  def up
     add_column :users, :chat_enabled, :boolean, :default => true
  end

  def down
    remove_column :users, :chat_enabled
  end
end

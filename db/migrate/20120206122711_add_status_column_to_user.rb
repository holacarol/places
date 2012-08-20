class AddStatusColumnToUser < ActiveRecord::Migration
  def up
     add_column :users, :status, :string, :default => "chat"
  end

  def down
    remove_column :users, :status
  end
end

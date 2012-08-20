class AddConnectedColumnToUser < ActiveRecord::Migration
  def up
     add_column :users, :connected, :boolean, :default => false
  end

  def down
    remove_column :users, :connected
  end
end

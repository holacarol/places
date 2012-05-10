class AddLatitudeAndLongitudeToPlace < ActiveRecord::Migration
  def up
  	remove_index :places, :column => :position
  	remove_column :places, :position
    add_column :places, :latitude, :float
    add_column :places, :longitude, :float
    add_index :places, [:latitude, :longitude]
  end

  def down
  	remove_index :places, [:latitude, :longitude]
  	remove_column :places, :latitude
  	remove_column :places, :longitude
  	add_column :places, :position, :string
  	add_index :places, :position
  end
end

class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :activity_object
      t.string :position
      t.references :address
      t.string :url

      t.timestamps
    end
    add_index :places, :activity_object_id
    add_index :places, :address_id
    add_index :places, :position
    add_foreign_key :places, :activity_objects, :name => 'places_on_activity_object_id'
    add_foreign_key :places, :addresses, :name => 'places_on_address_id'
  end
end

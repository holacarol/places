class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :formatted
      t.string :streetAddress
      t.string :locality
      t.string :region
      t.string :postalCode
      t.string :country

      t.timestamps
    end
    add_index :addresses, [:streetAddress, :locality]
  end
end

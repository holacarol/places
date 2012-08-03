class AddPhoneNumberToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :phone_number, :string
  end
end

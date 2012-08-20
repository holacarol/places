class AddLanguageField < ActiveRecord::Migration
  def up
    change_table "users" do |t|
      t.string "language", :default => "en"
    end
  end

  def down
    change_table :users do |t|
      t.remove "language"
    end
  end
end

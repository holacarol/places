class AddWidthHeightToLink < ActiveRecord::Migration
  def up
    change_table "links" do |t|
      t.integer "width",  :default => 470
      t.integer "height", :default => 353
    end
  end

  def down
    change_table :links do |t|
      t.remove "width"
      t.remove "height"
    end
  end
end

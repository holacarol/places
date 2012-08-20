class AddTitleAndDescriptionToDocument < ActiveRecord::Migration
    def up
      add_column :documents, :title, :string
      add_column :documents, :description, :text
    end
    
    def down
      remove_column :documents, :title
      remove_column :documents, :description
    end
end

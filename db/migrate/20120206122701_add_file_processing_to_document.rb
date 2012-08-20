class AddFileProcessingToDocument < ActiveRecord::Migration
    def up
      add_column :documents, :file_processing, :boolean
    end
    
    def down
      remove_column :documents, :file_processing
    end
end

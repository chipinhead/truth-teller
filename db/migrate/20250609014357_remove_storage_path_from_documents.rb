class RemoveStoragePathFromDocuments < ActiveRecord::Migration[8.0]
  def change
    remove_column :documents, :storage_path, :string
  end
end

class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.references :client, type: :uuid, null: false, foreign_key: true
      t.string :source_id, null: false
      t.integer :version, null: false
      t.string :title, null: false
      t.string :storage_path
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :documents, :version
    add_index :documents, [:client_id, :source_id]
    add_index :documents, :metadata, using: :gin
  end
end

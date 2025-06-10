class CreateDocumentChunks < ActiveRecord::Migration[8.0]
    def change
      create_table :document_chunks, id: :uuid do |t|
        t.references :document, null: false, foreign_key: true, type: :uuid
        t.integer :chunk_index, null: false
        t.integer :start, null: false
        t.integer :end, null: false
        t.text :content, null: false
        t.integer :token_count, null: false, default: 0
        t.string :embedding_model
        t.timestamps
      end
      add_index :document_chunks, [:document_id, :chunk_index], unique: true
    end
end
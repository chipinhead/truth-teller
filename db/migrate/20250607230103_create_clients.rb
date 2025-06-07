class CreateClients < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :clients, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :clients, :name
  end
end

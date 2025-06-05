class AddUuidToUsers < ActiveRecord::Migration[8.0]
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    # Add uuid column with a default value
    add_column :users, :uuid, :uuid, default: -> { "gen_random_uuid()" }, null: false

    # Add a unique index on uuid
    add_index :users, :uuid, unique: true

    # Remove the primary key constraint from id
    remove_column :users, :id

    # Rename uuid to id and make it the primary key
    rename_column :users, :uuid, :id
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end

  def down
    # Add back the id column as primary key
    add_column :users, :id, :bigint, primary_key: true

    # Remove the uuid column
    remove_column :users, :id

    # Disable the extension
    disable_extension 'pgcrypto' if extension_enabled?('pgcrypto')
  end
end

class AddCreatedUserToClients < ActiveRecord::Migration[8.0]
  def change
    add_reference :clients, :created_user, type: :uuid, null: false, foreign_key: { to_table: :users }
  end
end

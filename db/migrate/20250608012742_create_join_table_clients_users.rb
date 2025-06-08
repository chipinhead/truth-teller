class CreateJoinTableClientsUsers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :clients, :users, column_options: { type: :uuid } do |t|
      t.index [:client_id, :user_id], unique: true
      t.index [:user_id, :client_id]
    end
    
    add_foreign_key :clients_users, :clients, column: :client_id
    add_foreign_key :clients_users, :users, column: :user_id
  end
end

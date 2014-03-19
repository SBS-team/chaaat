class AddLoginToUser < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
<<<<<<< HEAD
    add_index :users, :login,                :unique => true
=======
    add_index :users, :login, :unique => true
>>>>>>> rooms_users_ajax
  end
end

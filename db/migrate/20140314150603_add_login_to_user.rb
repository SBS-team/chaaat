class AddLoginToUser < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
<<<<<<< HEAD
<<<<<<< HEAD
    add_index :users, :login,                :unique => true
=======
    add_index :users, :login, :unique => true
>>>>>>> rooms_users_ajax
=======
    add_index :users, :login, :unique => true
>>>>>>> 4e5c26566a116d042684198a641a5ba293a72979
  end
end

class AddFirstAndLastnameToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :name, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
  end
end

class AddSignOutAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sign_out_at, :datetime, :null => true
  end
end

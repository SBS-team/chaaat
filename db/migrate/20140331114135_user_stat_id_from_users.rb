class UserStatIdFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :user_stat_id
  	add_column :users, :user_status, :string
  end
end

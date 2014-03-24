class AddUserToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :user, :text
  end
end

class RemoveUserFromRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :user, :text
  end
end

class RenameUserIdToCreatorIdInRooms < ActiveRecord::Migration
  def change
    rename_column :rooms, :user_id, :creator_id
  end
end

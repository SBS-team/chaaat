class AddProgileAvatar < ActiveRecord::Migration
  def change
    add_column :users, :profile_avatar, :string
  end
end

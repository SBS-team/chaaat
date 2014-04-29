class ChangeStringFormatInUser < ActiveRecord::Migration
  def up
   change_column :users, :user_stat_id, :integer
  end

  def down
   change_column :users, :user_stat_id, :string
  end
end

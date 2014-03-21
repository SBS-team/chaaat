class AddStatusToUser < ActiveRecord::Migration
  def change
    add_reference :users, :user_stat, index: true
  end
end

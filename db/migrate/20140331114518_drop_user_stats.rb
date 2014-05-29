class DropUserStats < ActiveRecord::Migration
  def change
  	drop_table :user_stats
  end
end

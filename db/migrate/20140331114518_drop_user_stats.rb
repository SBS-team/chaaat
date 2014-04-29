class DropUserStats < ActiveRecord::Migration
  def change
  	drop_table :user_stats
    #FIXME add indexes to all relationship
  end
end

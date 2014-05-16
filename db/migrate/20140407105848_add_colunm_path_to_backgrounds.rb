class AddColunmPathToBackgrounds < ActiveRecord::Migration
  def change
    add_column :backgrounds, :path, :text
  end
end

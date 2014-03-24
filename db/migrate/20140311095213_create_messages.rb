class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.text :body
      t.text :attach_path
      t.text :attach_size
      t.references :room, index: true

      t.timestamps
    end
  end
end

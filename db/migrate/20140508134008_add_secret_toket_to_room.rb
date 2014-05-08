class AddSecretToketToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :secret_token, :string
  end
end

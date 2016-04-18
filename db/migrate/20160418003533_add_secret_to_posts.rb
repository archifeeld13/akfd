class AddSecretToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_secret, :boolean, :default => false 
  end
end

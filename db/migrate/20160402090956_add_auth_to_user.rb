class AddAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :my_auth, :boolean, :default => false 
  end
end

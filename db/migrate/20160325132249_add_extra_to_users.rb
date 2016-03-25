class AddExtraToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo, :string
    add_column :users, :email, :string
    add_column :users, :nickname, :string
    add_column :users, :company, :string
    add_column :users, :password, :string
    add_column :users, :use_nick, :boolean, default: false;
    add_column :users, :use_photo, :boolean, default: false;
    add_column :users, :user_type, :integer, default: 0;
  end
end

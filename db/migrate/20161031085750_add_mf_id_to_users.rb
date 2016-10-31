class AddMfIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mf_id, :string
    add_index :users, :mf_id, unique: true
  end
end

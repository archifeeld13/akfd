class RemoveImgOrderFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :img_order, :string
  end
end

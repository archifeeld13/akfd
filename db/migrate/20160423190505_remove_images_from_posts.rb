class RemoveImagesFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :images, :text
  end
end

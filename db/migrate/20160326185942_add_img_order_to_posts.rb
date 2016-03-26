class AddImgOrderToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :img_order, :string
  end
end

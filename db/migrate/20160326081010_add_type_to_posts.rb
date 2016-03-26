class AddTypeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_type, :Integer
  end
end

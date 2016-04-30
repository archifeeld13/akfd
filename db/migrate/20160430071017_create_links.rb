class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :post, index: true, foreign_key: true
      t.string :link_title
      t.string :image_url, :default => nil 
      t.string :link_url

      t.timestamps null: false
    end
  end
end

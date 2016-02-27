class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
			
			t.string :title
			t.text :content
			
			# 사진은 아직
			# 태그는 아직 

      t.timestamps null: false
    end
  end
end

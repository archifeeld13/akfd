class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :target_id
      t.integer :event_type
      t.references :post, index: true, foreign_key: true
      t.boolean :check

      t.timestamps null: false
    end
  end
end

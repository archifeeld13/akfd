class CreateBackgrounds < ActiveRecord::Migration
  def change
    create_table :backgrounds do |t|
      t.string :photo
      t.string :author

      t.timestamps null: false
    end
  end
end

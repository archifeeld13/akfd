class CreateEmailAuths < ActiveRecord::Migration
  def change
    create_table :email_auths do |t|
      t.string :auth_key
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

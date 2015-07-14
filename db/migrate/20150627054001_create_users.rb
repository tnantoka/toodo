class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname, null: false
      t.text :image
      t.string :username, null: false
      t.string :token, null: false
      t.boolean :gist, null: false, default: false

      t.timestamps null: false
    end

    add_index :users, :nickname, unique: true
  end
end

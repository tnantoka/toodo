class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title, null: false
      t.text :content, limit: 16.megabytes - 1
      t.string :slug, null: false
      t.boolean :gist, null: false, default: false
      t.string :gist_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :lists, [:title, :user_id], unique: true
    add_index :lists, :slug, unique: true
    add_index :lists, :updated_at
  end
end

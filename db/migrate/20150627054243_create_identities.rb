class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.text :raw, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :identities, [:uid, :provider], unique: true
  end
end

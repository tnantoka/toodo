# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150628130419) do

  create_table "identities", force: :cascade do |t|
    t.string   "uid",        limit: 255,   null: false
    t.string   "provider",   limit: 255,   null: false
    t.text     "raw",        limit: 65535, null: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "identities", ["uid", "provider"], name: "index_identities_on_uid_and_provider", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "title",      limit: 255,                      null: false
    t.text     "content",    limit: 16777215
    t.string   "slug",       limit: 255,                      null: false
    t.boolean  "gist",                        default: false, null: false
    t.string   "gist_id",    limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "lists", ["slug"], name: "index_lists_on_slug", unique: true, using: :btree
  add_index "lists", ["title", "user_id"], name: "index_lists_on_title_and_user_id", unique: true, using: :btree
  add_index "lists", ["updated_at"], name: "index_lists_on_updated_at", using: :btree
  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "nickname",   limit: 255,                   null: false
    t.text     "image",      limit: 65535
    t.string   "username",   limit: 255,                   null: false
    t.string   "token",      limit: 255,                   null: false
    t.boolean  "gist",                     default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree

  add_foreign_key "identities", "users"
  add_foreign_key "lists", "users"
end

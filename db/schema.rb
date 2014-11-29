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

ActiveRecord::Schema.define(version: 20141129125313) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "api_key"
    t.string   "api_secret"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.string   "target"
    t.string   "description"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pattern"
  end

  add_index "accounts", ["group_id"], name: "index_accounts_on_group_id"

  create_table "followed_users", force: true do |t|
    t.integer  "account_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "checked"
    t.integer  "status"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statements", force: true do |t|
    t.string   "contents"
    t.integer  "priority"
    t.integer  "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

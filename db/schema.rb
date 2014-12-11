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

ActiveRecord::Schema.define(version: 20141210062020) do

  create_table "account_retweets", force: true do |t|
    t.integer  "account_id"
    t.integer  "retweet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "api_key"
    t.string   "api_secret"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.string   "description"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pattern"
    t.integer  "follower_num",        default: 0
    t.integer  "follow_num",          default: 0
    t.datetime "followed_at",         default: '2014-12-04 00:20:57'
    t.datetime "unfollowed_at",       default: '2014-12-04 00:20:57'
    t.boolean  "auto_retweet",        default: false
    t.datetime "auto_retweeted_at",   default: '2014-12-04 00:20:57'
    t.datetime "auto_tweeted_at",     default: '2014-12-07 06:27:11'
    t.boolean  "auto_tweet",          default: false
    t.integer  "target_id"
  end

  add_index "accounts", ["group_id"], name: "index_accounts_on_group_id"
  add_index "accounts", ["target_id"], name: "index_accounts_on_target_id"

  create_table "followed_users", force: true do |t|
    t.integer  "account_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "checked"
    t.integer  "status"
  end

  add_index "followed_users", ["account_id"], name: "index_followed_users_on_account_id"
  add_index "followed_users", ["status"], name: "index_followed_users_on_status"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retweets", force: true do |t|
    t.string   "url"
    t.integer  "group_id"
    t.datetime "start_at"
    t.integer  "interval"
    t.integer  "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     default: 0
    t.integer  "account_id", default: 0
  end

  add_index "retweets", ["group_id"], name: "index_retweets_on_group_id"
  add_index "retweets", ["status"], name: "index_retweets_on_status"

  create_table "statements", force: true do |t|
    t.string   "contents"
    t.integer  "priority"
    t.integer  "pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "targets", force: true do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "tweets", force: true do |t|
    t.string   "tweet_id"
    t.string   "text"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

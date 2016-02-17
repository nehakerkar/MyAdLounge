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

ActiveRecord::Schema.define(version: 20160216182838) do

  create_table "adgroups", force: :cascade do |t|
    t.integer  "campaign_id",  limit: 4
    t.string   "aname",        limit: 255
    t.float    "maxcpc",       limit: 24
    t.string   "headline",     limit: 255
    t.text     "description1", limit: 65535
    t.text     "description2", limit: 65535
    t.string   "displayurl",   limit: 255
    t.string   "finalurl",     limit: 255
    t.string   "status",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "adgroups", ["campaign_id", "aname"], name: "index_adgroups_on_campaign_id_and_aname", unique: true, using: :btree
  add_index "adgroups", ["campaign_id"], name: "index_adgroups_on_campaign_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.integer  "adgroup_id",    limit: 4
    t.string   "keyword",       limit: 255
    t.string   "criteriontype", limit: 255
    t.float    "firstpagebid",  limit: 24
    t.float    "topofpagebid",  limit: 24
    t.string   "status",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "ads", ["adgroup_id", "keyword"], name: "index_ads_on_adgroup_id_and_keyword", unique: true, using: :btree
  add_index "ads", ["adgroup_id"], name: "index_ads_on_adgroup_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "cname",               limit: 255
    t.float    "campaigndailybudget", limit: 24
    t.string   "status",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "campaigns", ["user_id", "cname"], name: "index_campaigns_on_user_id_and_cname", unique: true, using: :btree
  add_index "campaigns", ["user_id"], name: "index_campaigns_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "adgroups", "campaigns"
  add_foreign_key "ads", "adgroups"
  add_foreign_key "campaigns", "users"
end

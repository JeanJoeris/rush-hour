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

ActiveRecord::Schema.define(version: 20160824204914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string   "os"
    t.string   "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ips", force: :cascade do |t|
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payload_requests", force: :cascade do |t|
    t.datetime "requested_at"
    t.integer  "responded_in"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "url_id"
    t.integer  "ip_id"
    t.integer  "referral_url_id"
    t.integer  "agent_id"
    t.integer  "screen_resolution_id"
    t.integer  "request_type_id"
  end

  create_table "referrers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_types", force: :cascade do |t|
    t.string   "http_verb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "screen_resolutions", force: :cascade do |t|
    t.string   "width"
    t.string   "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "urls", force: :cascade do |t|
    t.string   "url_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

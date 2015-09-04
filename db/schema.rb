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

ActiveRecord::Schema.define(version: 20150818225711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_admins", force: :cascade do |t|
    t.string   "name",           limit: 255,               null: false
    t.string   "email",          limit: 255,               null: false
    t.string   "password_salt",  limit: 255,               null: false
    t.string   "password_hash",  limit: 255,               null: false
    t.string   "role",           limit: 255, default: "1", null: false
    t.string   "remember_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.integer  "login_count",                default: 0
    t.string   "last_login_ip",  limit: 255
  end

  add_index "admin_admins", ["email"], name: "index_admin_admins_on_email", unique: true, using: :btree

  create_table "clamps", force: :cascade do |t|
    t.datetime "time"
    t.decimal  "duration"
    t.string   "type",       limit: 255
    t.integer  "device_id"
    t.integer  "packet_id"
    t.float    "dur_float",              default: 0.0
    t.datetime "created_at",             default: "now()"
    t.datetime "updated_at",             default: "now()"
  end

  add_index "clamps", ["device_id", "time"], name: "index_clamps_on_device_id_time", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "name",                 limit: 255,                 null: false
    t.string   "sensor_readings",      limit: 255
    t.string   "schedule",             limit: 255
    t.text     "description"
    t.integer  "user_id",                                          null: false
    t.string   "status",               limit: 255, default: "new"
    t.string   "imei",                 limit: 255,                 null: false
    t.string   "imei_substr",          limit: 255,                 null: false
    t.string   "slot_number",          limit: 255,                 null: false
    t.string   "interval",             limit: 255,                 null: false
    t.string   "normal_cycle",         limit: 255,                 null: false
    t.string   "material_consumption", limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "state"
    t.string   "device_type",          limit: 255
  end

  add_index "devices", ["status"], name: "index_devices_on_status", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "packets", force: :cascade do |t|
    t.string   "imei_substr", limit: 255,                 null: false
    t.text     "content"
    t.datetime "created_at"
    t.string   "type",        limit: 255
    t.string   "version",     limit: 255
    t.string   "sim_balance", limit: 255
    t.boolean  "decoded",                 default: false
    t.integer  "device_id"
    t.datetime "updated_at"
  end

  add_index "packets", ["device_id"], name: "index_packets_on_device_id", using: :btree
  add_index "packets", ["imei_substr"], name: "index_packets_on_imei_substr", using: :btree

  create_table "pings", force: :cascade do |t|
    t.datetime "ping_was"
    t.datetime "ping_will"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pings", ["device_id"], name: "index_pings_on_device_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "sim_balance", limit: 255
    t.string   "temp",        limit: 255
    t.string   "v_batt",      limit: 255
    t.string   "gis",         limit: 255
    t.datetime "datetime"
    t.integer  "device_id"
    t.datetime "created_at"
    t.string   "rssi",        limit: 255
  end

  add_index "states", ["device_id"], name: "index_states_on_device_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255,                    null: false
    t.string   "role",                   limit: 255, default: "1",      null: false
    t.string   "company",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",       null: false
    t.string   "encrypted_password",     limit: 255, default: "",       null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.boolean  "banned"
    t.string   "time_zone",              limit: 255, default: "Moscow"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

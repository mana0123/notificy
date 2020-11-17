# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_21_070048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_admin_users_on_name", unique: true
  end

  create_table "schedule_item_dates", force: :cascade do |t|
    t.bigint "schedule_item_id", null: false
    t.integer "year"
    t.integer "month"
    t.integer "week"
    t.integer "day"
    t.integer "hour"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day"], name: "index_schedule_item_dates_on_day"
    t.index ["hour"], name: "index_schedule_item_dates_on_hour"
    t.index ["month"], name: "index_schedule_item_dates_on_month"
    t.index ["schedule_item_id"], name: "index_schedule_item_dates_on_schedule_item_id"
    t.index ["week"], name: "index_schedule_item_dates_on_week"
    t.index ["year"], name: "index_schedule_item_dates_on_year"
  end

  create_table "schedule_items", force: :cascade do |t|
    t.string "user_id", null: false
    t.integer "status", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_schedule_items_on_user_id"
  end

  create_table "users", primary_key: "line_id", id: :string, force: :cascade do |t|
    t.string "user_type", null: false
    t.integer "status", null: false
    t.string "access_token_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "schedule_item_dates", "schedule_items"
  add_foreign_key "schedule_items", "users", primary_key: "line_id"
end

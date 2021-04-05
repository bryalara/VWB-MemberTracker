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

ActiveRecord::Schema.define(version: 2021_04_03_054357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "edithomepages", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_attendees", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
    t.index ["user_id", "event_id"], name: "index_event_attendees_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_event_attendees_on_user_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "startDate"
    t.datetime "endDate"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "point_event_attendees", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "point_event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["point_event_id"], name: "index_point_event_attendees_on_point_event_id"
    t.index ["user_id", "point_event_id"], name: "index_point_event_attendees_on_user_id_and_point_event_id", unique: true
    t.index ["user_id"], name: "index_point_event_attendees_on_user_id"
  end

  create_table "point_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "userlogins", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_userlogins_on_email", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.integer "role", default: 0, null: false
    t.string "firstName", null: false
    t.string "lastName", null: false
    t.string "phoneNumber", null: false
    t.string "classification", null: false
    t.string "tShirtSize", null: false
    t.boolean "optInEmail", default: true, null: false
    t.integer "participationPoints", default: 0, null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "users"
  add_foreign_key "point_event_attendees", "point_events"
  add_foreign_key "point_event_attendees", "users"
end

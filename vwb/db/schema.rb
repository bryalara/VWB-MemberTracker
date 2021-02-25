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

ActiveRecord::Schema.define(version: 2021_02_15_210059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "startDate"
    t.datetime "endDate"
    t.integer "points"
    t.string "eventType"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "point_events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "points"
    t.string "eventType"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "emailneeded", null: false
    t.integer "role", default: 0, null: false
    t.string "firstName", default: "FirstName", null: false
    t.string "lastName", default: "LastName", null: false
    t.string "phoneNumber", default: "1234567890", null: false
    t.string "classification", default: "Freshmen", null: false
    t.string "tShirtSize", default: "M", null: false
    t.boolean "optInEmail", default: true, null: false
    t.integer "participationPoints", default: 0, null: false
    t.boolean "approved", default: true, null: false

    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

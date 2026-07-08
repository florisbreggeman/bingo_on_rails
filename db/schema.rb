# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_08_173214) do
  create_table "cards", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "free_space"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", default: 1, null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "fields", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.string "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_fields_on_card_id"
  end

  create_table "sessions", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "cards", "users"
  add_foreign_key "fields", "cards"
  add_foreign_key "sessions", "users"
end

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

ActiveRecord::Schema[8.1].define(version: 2026_04_09_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.decimal "cost", precision: 9, scale: 2
    t.datetime "created_at", null: false
    t.date "published_on"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.string "ip_address", null: false
    t.string "session_token", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "session_token"], name: "index_votes_on_book_id_and_session_token", unique: true
    t.index ["book_id"], name: "index_votes_on_book_id"
    t.index ["session_token"], name: "index_votes_on_session_token"
  end

  add_foreign_key "votes", "books"
end

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

ActiveRecord::Schema[7.0].define(version: 2022_08_18_224213) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "integer_id"
    t.text "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "collection_id"
    t.index ["collection_id"], name: "index_notes_on_collection_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notes_tags", id: false, force: :cascade do |t|
    t.uuid "note_id", null: false
    t.uuid "tag_id", null: false
    t.index ["note_id", "tag_id"], name: "index_notes_tags_on_note_id_and_tag_id"
    t.index ["note_id"], name: "index_notes_tags_on_note_id"
    t.index ["tag_id", "note_id"], name: "index_notes_tags_on_tag_id_and_note_id"
    t.index ["tag_id"], name: "index_notes_tags_on_tag_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "tags_notes", id: false, force: :cascade do |t|
    t.uuid "note_id", null: false
    t.uuid "tag_id", null: false
    t.index ["note_id", "tag_id"], name: "index_tags_notes_on_note_id_and_tag_id"
    t.index ["note_id"], name: "index_tags_notes_on_note_id"
    t.index ["tag_id", "note_id"], name: "index_tags_notes_on_tag_id_and_note_id"
    t.index ["tag_id"], name: "index_tags_notes_on_tag_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collections", "users"
  add_foreign_key "notes", "collections"
  add_foreign_key "notes", "users"
  add_foreign_key "notes_tags", "notes"
  add_foreign_key "notes_tags", "tags"
  add_foreign_key "tags", "users"
  add_foreign_key "tags_notes", "notes"
  add_foreign_key "tags_notes", "tags"
end

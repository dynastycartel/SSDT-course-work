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

ActiveRecord::Schema[7.0].define(version: 2023_11_26_160755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "commenting_user_id"
    t.bigint "commented_user_id"
    t.bigint "score"
    t.text "body"
    t.boolean "support", default: false
    t.datetime "publish_datetime", precision: nil
    t.index ["commented_user_id"], name: "index_comments_on_commented_user_id"
    t.index ["commenting_user_id"], name: "index_comments_on_commenting_user_id"
  end

  create_table "exchange_items", force: :cascade do |t|
    t.bigint "posted_item_id"
    t.string "desired_item_name", null: false
    t.datetime "publish_datetime", precision: nil
    t.index ["posted_item_id"], name: "index_exchange_items_on_posted_item_id"
  end

  create_table "game_accounts", force: :cascade do |t|
    t.string "login", null: false
    t.string "password_digest", null: false
    t.integer "user_id"
    t.integer "recommended_price", null: false
    t.boolean "selling", default: false
    t.boolean "confirmed", default: false
  end

  create_table "items", force: :cascade do |t|
    t.bigint "game_account_id"
    t.string "game", null: false
    t.string "name", null: false
    t.string "rarity", null: false
    t.integer "recommended_price", null: false
    t.boolean "selling", default: false
    t.index ["game_account_id"], name: "index_items_on_game_account_id"
  end

  create_table "selling_accounts", force: :cascade do |t|
    t.bigint "game_account_id"
    t.bigint "seller_id"
    t.integer "price"
    t.datetime "publish_datetime", precision: nil
    t.index ["game_account_id"], name: "index_selling_accounts_on_game_account_id"
    t.index ["seller_id"], name: "index_selling_accounts_on_seller_id"
  end

  create_table "selling_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "seller_account_id"
    t.integer "price"
    t.datetime "publish_datetime", precision: nil
    t.index ["item_id"], name: "index_selling_items_on_item_id"
    t.index ["seller_account_id"], name: "index_selling_items_on_seller_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", default: "", null: false
    t.string "password_digest", null: false
    t.string "secret_word", null: false
    t.boolean "superuser", default: false, null: false
    t.integer "balance", default: 50
    t.text "bio"
    t.float "score", default: 0.0
    t.integer "reports", default: 0
    t.boolean "banned", default: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users", column: "commented_user_id"
  add_foreign_key "comments", "users", column: "commenting_user_id"
  add_foreign_key "exchange_items", "items", column: "posted_item_id"
  add_foreign_key "items", "game_accounts"
  add_foreign_key "selling_accounts", "game_accounts"
  add_foreign_key "selling_accounts", "users", column: "seller_id"
  add_foreign_key "selling_items", "game_accounts", column: "seller_account_id"
  add_foreign_key "selling_items", "items"
end

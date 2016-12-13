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

ActiveRecord::Schema.define(version: 20161212070632) do

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "ancestry",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "text",             limit: 65535
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.integer  "role",             limit: 4,     default: 0
    t.integer  "status",           limit: 4,     default: 0
    t.boolean  "read",                           default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "item_file_name",    limit: 255
    t.string   "item_content_type", limit: 255
    t.integer  "item_file_size",    limit: 4
    t.datetime "item_updated_at"
    t.integer  "imageable_id",      limit: 4
    t.string   "imageable_type",    limit: 255
    t.integer  "position",          limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "category_id", limit: 4
    t.integer  "shop_id",     limit: 4
    t.string   "title",       limit: 255
    t.integer  "stock",       limit: 4
    t.decimal  "price",                     precision: 8, scale: 2
    t.text     "description", limit: 65535
    t.integer  "special",     limit: 4,                             default: 0
    t.integer  "status",      limit: 4,                             default: 0
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["shop_id"], name: "index_products_on_shop_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "sheds", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shops", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "shed_id",            limit: 4
    t.integer  "category_id",        limit: 4
    t.string   "description",        limit: 255
    t.integer  "location",           limit: 4
    t.string   "location_detail",    limit: 255
    t.string   "between_down",       limit: 255
    t.string   "between_up",         limit: 255
    t.integer  "number_id",          limit: 4
    t.string   "letter_id",          limit: 255
    t.boolean  "fixed"
    t.string   "opens",              limit: 255
    t.integer  "condition",          limit: 4
    t.integer  "rating",             limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "status",             limit: 4,   default: 0
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "shops", ["category_id"], name: "index_shops_on_category_id", using: :btree
  add_index "shops", ["shed_id"], name: "index_shops_on_shed_id", using: :btree
  add_index "shops", ["user_id"], name: "index_shops_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255
    t.string   "nickname",               limit: 255
    t.string   "image",                  limit: 255
    t.string   "email",                  limit: 255
    t.integer  "role",                   limit: 4
    t.string   "io_uid",                 limit: 255
    t.string   "id_type",                limit: 255
    t.string   "id_number",              limit: 255
    t.integer  "gender",                 limit: 4
    t.date     "birthday"
    t.string   "phone_number",           limit: 255
    t.string   "address",                limit: 255
    t.string   "locality",               limit: 255
    t.text     "metadata",               limit: 65535
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "comments", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "products", "users"
  add_foreign_key "shops", "categories"
  add_foreign_key "shops", "sheds"
  add_foreign_key "shops", "users"
end

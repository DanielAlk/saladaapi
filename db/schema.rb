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

ActiveRecord::Schema.define(version: 20210524034302) do

  create_table "admin_notifications", force: :cascade do |t|
    t.integer  "kind",           limit: 4,     default: 0
    t.integer  "alertable_id",   limit: 4
    t.string   "alertable_type", limit: 255
    t.text     "metadata",       limit: 65535
    t.integer  "status",         limit: 4,     default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "admin_notifications", ["alertable_type", "alertable_id"], name: "index_admin_notifications_on_alertable_type_and_alertable_id", using: :btree

  create_table "ads", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "text",               limit: 65535
    t.text     "actions",            limit: 65535
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size",    limit: 4
    t.datetime "cover_updated_at"
    t.integer  "special",            limit: 4,     default: 0
    t.integer  "status",             limit: 4,     default: 0
    t.integer  "kind",               limit: 4,     default: 0
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "app_configs", force: :cascade do |t|
    t.string   "sid",        limit: 255
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "app_configs", ["sid"], name: "index_app_configs_on_sid", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "ancestry",   limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_role",  limit: 4,   default: 0
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
    t.integer  "interaction_id",   limit: 4
    t.integer  "receiver_id",      limit: 4
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["interaction_id"], name: "index_comments_on_interaction_id", using: :btree
  add_index "comments", ["receiver_id"], name: "index_comments_on_receiver_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "tel",        limit: 255
    t.text     "message",    limit: 65535
    t.integer  "role",       limit: 4
    t.integer  "subject",    limit: 4,     default: 0
    t.boolean  "read",                     default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "histories", ["product_id"], name: "index_histories_on_product_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

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

  create_table "interactions", force: :cascade do |t|
    t.integer  "product_id",      limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "owner_id",        limit: 4
    t.integer  "last_comment_id", limit: 4
  end

  add_index "interactions", ["last_comment_id"], name: "index_interactions_on_last_comment_id", using: :btree
  add_index "interactions", ["owner_id"], name: "index_interactions_on_owner_id", using: :btree
  add_index "interactions", ["product_id"], name: "index_interactions_on_product_id", using: :btree
  add_index "interactions", ["user_id"], name: "index_interactions_on_user_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.string   "mercadopago_invoice_id",      limit: 255
    t.string   "mercadopago_subscription_id", limit: 255
    t.string   "mercadopago_plan_id",         limit: 255
    t.integer  "subscription_id",             limit: 4
    t.integer  "plan_id",                     limit: 4
    t.integer  "user_id",                     limit: 4
    t.text     "payer",                       limit: 65535
    t.float    "application_fee",             limit: 24
    t.integer  "status",                      limit: 4
    t.string   "description",                 limit: 255
    t.text     "metadata",                    limit: 65535
    t.text     "payments",                    limit: 65535
    t.datetime "debit_date"
    t.datetime "next_payment_attempt"
    t.text     "mercadopago_invoice",         limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "invoices", ["mercadopago_invoice_id"], name: "index_invoices_on_mercadopago_invoice_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.integer  "payable_id",             limit: 4
    t.string   "payable_type",           limit: 255
    t.integer  "promotionable_id",       limit: 4
    t.string   "promotionable_type",     limit: 255
    t.integer  "kind",                   limit: 4,                             default: 0
    t.decimal  "transaction_amount",                   precision: 8, scale: 2
    t.integer  "installments",           limit: 4,                             default: 1
    t.decimal  "shipment_cost",                        precision: 8, scale: 2
    t.integer  "status",                 limit: 4
    t.string   "status_detail",          limit: 255
    t.string   "payment_method_id",      limit: 255
    t.string   "token",                  limit: 255
    t.text     "additional_info",        limit: 65535
    t.text     "mercadopago_payment",    limit: 65535
    t.integer  "mercadopago_payment_id", limit: 8
    t.boolean  "save_address",                                                 default: false
    t.boolean  "save_card",                                                    default: false
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
  end

  add_index "payments", ["payable_type", "payable_id"], name: "index_payments_on_payable_type_and_payable_id", using: :btree
  add_index "payments", ["promotionable_type", "promotionable_id"], name: "index_payments_on_promotionable_type_and_promotionable_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "plan_groups", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.integer  "kind",               limit: 4,                             default: 0
    t.integer  "subscriptable_role", limit: 4
    t.decimal  "starting_price",                   precision: 8, scale: 2
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.integer  "premium_type",       limit: 4,                             default: 0
  end

  create_table "plans", force: :cascade do |t|
    t.string   "mercadopago_plan_id", limit: 255
    t.integer  "plan_group_id",       limit: 4
    t.string   "name",                limit: 255
    t.string   "title",               limit: 255
    t.integer  "kind",                limit: 4,                             default: 0
    t.decimal  "price",                             precision: 8, scale: 2
    t.integer  "frequency",           limit: 4
    t.integer  "frequency_type",      limit: 4,                             default: 0
    t.float    "application_fee",     limit: 24
    t.integer  "status",              limit: 4
    t.string   "description",         limit: 255
    t.text     "auto_recurring",      limit: 65535
    t.text     "metadata",            limit: 65535
    t.text     "mercadopago_plan",    limit: 65535
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "plans", ["mercadopago_plan_id"], name: "index_plans_on_mercadopago_plan_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "subtitle",           limit: 255
    t.text     "text",               limit: 65535
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size",    limit: 4
    t.datetime "cover_updated_at"
    t.integer  "status",             limit: 4,     default: 0
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "video_id",           limit: 255
  end

  create_table "product_buy_clicks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "product_buy_clicks", ["product_id"], name: "index_product_buy_clicks_on_product_id", using: :btree
  add_index "product_buy_clicks", ["user_id"], name: "index_product_buy_clicks_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "category_id",       limit: 4
    t.integer  "shop_id",           limit: 4
    t.string   "title",             limit: 255
    t.integer  "stock",             limit: 4
    t.decimal  "price",                           precision: 8, scale: 2
    t.text     "description",       limit: 65535
    t.integer  "special",           limit: 4,                             default: 0
    t.integer  "status",            limit: 4,                             default: 0
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.date     "available_at"
    t.boolean  "is_retailer",                                             default: false
    t.integer  "wholesaler_amount", limit: 4
    t.integer  "shipping_amount",   limit: 4
    t.decimal  "retailer_price",                  precision: 8, scale: 2
    t.decimal  "shipping_price",                  precision: 8, scale: 2
    t.string   "video_id",          limit: 255
    t.decimal  "rating",                          precision: 2, scale: 1
    t.boolean  "provider_product",                                        default: false
    t.integer  "minimum_amount",    limit: 4
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["shop_id"], name: "index_products_on_shop_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "title",         limit: 255
    t.integer  "kind",          limit: 4,                             default: 0
    t.text     "description",   limit: 65535
    t.decimal  "price",                       precision: 8, scale: 2
    t.integer  "duration",      limit: 4
    t.integer  "duration_type", limit: 4,                             default: 0
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  create_table "queries", force: :cascade do |t|
    t.text     "search",     limit: 65535
    t.integer  "count",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.text     "text",       limit: 65535
    t.integer  "stars",      limit: 4
    t.boolean  "is_visible"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sheds", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "shop_claims", force: :cascade do |t|
    t.integer  "status",     limit: 4, default: 0
    t.integer  "user_id",    limit: 4
    t.integer  "shop_id",    limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "state",      limit: 4, default: 1
  end

  add_index "shop_claims", ["shop_id"], name: "index_shop_claims_on_shop_id", using: :btree
  add_index "shop_claims", ["user_id"], name: "index_shop_claims_on_user_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "shed_id",            limit: 4
    t.integer  "category_id",        limit: 4
    t.string   "description",        limit: 255
    t.integer  "location",           limit: 4
    t.string   "location_detail",    limit: 255
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
    t.integer  "status",             limit: 4,                            default: 0
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "location_floor",     limit: 4
    t.integer  "location_row",       limit: 4
    t.string   "gallery_name",       limit: 255
    t.decimal  "latitude",                       precision: 12, scale: 9
    t.decimal  "longitude",                      precision: 12, scale: 9
    t.integer  "product_count",      limit: 4,                            default: 0
    t.string   "payment_methods",    limit: 255
    t.string   "shipping_company",   limit: 255
    t.string   "location_string",    limit: 255
  end

  add_index "shops", ["category_id"], name: "index_shops_on_category_id", using: :btree
  add_index "shops", ["shed_id"], name: "index_shops_on_shed_id", using: :btree
  add_index "shops", ["user_id"], name: "index_shops_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "mercadopago_subscription_id", limit: 255
    t.string   "mercadopago_plan_id",         limit: 255
    t.integer  "plan_id",                     limit: 4
    t.integer  "user_id",                     limit: 4
    t.integer  "kind",                        limit: 4
    t.text     "payer",                       limit: 65535
    t.string   "payment_method_id",           limit: 255
    t.string   "token",                       limit: 255
    t.float    "application_fee",             limit: 24
    t.integer  "status",                      limit: 4
    t.string   "description",                 limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "next_payment_date"
    t.text     "metadata",                    limit: 65535
    t.text     "charges_detail",              limit: 65535
    t.float    "setup_fee",                   limit: 24
    t.text     "mercadopago_subscription",    limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "subscriptions", ["mercadopago_subscription_id"], name: "index_subscriptions_on_mercadopago_subscription_id", using: :btree

  create_table "user_phone_numbers", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "phone_number", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

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
    t.integer  "badge_number",           limit: 4,     default: 0
    t.string   "customer_id",            limit: 255
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "special",                limit: 4,     default: 0
    t.integer  "phone_numbers_limit",    limit: 4,     default: 0
    t.string   "id_image_file_name",     limit: 255
    t.string   "id_image_content_type",  limit: 255
    t.integer  "id_image_file_size",     limit: 4
    t.datetime "id_image_updated_at"
    t.integer  "premium_type",           limit: 4,     default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "comments", "interactions"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "users", column: "receiver_id"
  add_foreign_key "histories", "products"
  add_foreign_key "histories", "users"
  add_foreign_key "interactions", "comments", column: "last_comment_id"
  add_foreign_key "interactions", "products"
  add_foreign_key "interactions", "users"
  add_foreign_key "interactions", "users", column: "owner_id"
  add_foreign_key "payments", "users"
  add_foreign_key "product_buy_clicks", "products"
  add_foreign_key "product_buy_clicks", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "products", "users"
  add_foreign_key "shop_claims", "shops"
  add_foreign_key "shop_claims", "users"
  add_foreign_key "shops", "categories"
  add_foreign_key "shops", "sheds"
  add_foreign_key "shops", "users"
end

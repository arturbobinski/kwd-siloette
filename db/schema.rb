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

ActiveRecord::Schema.define(version: 20160721080024) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "kind",        limit: 4,   default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "categories", ["kind"], name: "index_categories_on_kind", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "address",       limit: 255
    t.string   "country",       limit: 255
    t.string   "postal_code",   limit: 255
    t.float    "lat",           limit: 24
    t.float    "lng",           limit: 24
    t.string   "location_type", limit: 255
    t.integer  "owner_id",      limit: 4
    t.string   "owner_type",    limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "locations", ["deleted_at"], name: "index_locations_on_deleted_at", using: :btree
  add_index "locations", ["owner_id", "owner_type"], name: "index_locations_on_owner_id_and_owner_type", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.string   "slug",       limit: 255
    t.boolean  "active",                   default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "for_dancer",               default: false
  end

  add_index "pages", ["active"], name: "index_pages_on_active", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "perform_name", limit: 255
    t.date     "birth_date"
    t.string   "phone_number", limit: 255
    t.integer  "ethnicity",    limit: 4
    t.integer  "bust",         limit: 4
    t.float    "weight",       limit: 24
    t.float    "height",       limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "profiles", ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "service_images", force: :cascade do |t|
    t.integer  "service_id", limit: 4
    t.integer  "author_id",  limit: 4
    t.string   "file",       limit: 255
    t.boolean  "profile",                default: false
    t.integer  "width",      limit: 4
    t.integer  "height",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "service_images", ["author_id"], name: "index_service_images_on_author_id", using: :btree
  add_index "service_images", ["deleted_at"], name: "index_service_images_on_deleted_at", using: :btree
  add_index "service_images", ["service_id"], name: "index_service_images_on_service_id", using: :btree

  create_table "service_invitations", force: :cascade do |t|
    t.integer  "service_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "status",     limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "service_invitations", ["service_id"], name: "index_service_invitations_on_service_id", using: :btree
  add_index "service_invitations", ["status"], name: "index_service_invitations_on_status", using: :btree
  add_index "service_invitations", ["user_id"], name: "index_service_invitations_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "title",            limit: 255
    t.text     "description",      limit: 65535
    t.integer  "category_id",      limit: 4
    t.boolean  "open",                           default: true
    t.integer  "status",           limit: 4,     default: 0
    t.float    "rating",           limit: 24,    default: 0.0
    t.integer  "price_cents",      limit: 4,     default: 0
    t.string   "currency",         limit: 255,   default: "usd"
    t.integer  "quantity",         limit: 4,     default: 1
    t.integer  "views_count",      limit: 4,     default: 0
    t.integer  "comments_count",   limit: 4,     default: 0
    t.integer  "performers_count", limit: 4,     default: 1
    t.integer  "ethnicity",        limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "services", ["category_id"], name: "index_services_on_category_id", using: :btree
  add_index "services", ["deleted_at"], name: "index_services_on_deleted_at", using: :btree
  add_index "services", ["ethnicity"], name: "index_services_on_ethnicity", using: :btree
  add_index "services", ["open"], name: "index_services_on_open", using: :btree
  add_index "services", ["performers_count"], name: "index_services_on_performers_count", using: :btree
  add_index "services", ["price_cents"], name: "index_services_on_price_cents", using: :btree
  add_index "services", ["rating"], name: "index_services_on_rating", using: :btree
  add_index "services", ["status"], name: "index_services_on_status", using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255,   null: false
    t.text     "value",      limit: 65535
    t.integer  "thing_id",   limit: 4
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "slug",                   limit: 255
    t.integer  "role",                   limit: 4,     default: 0
    t.string   "avatar",                 limit: 255
    t.integer  "gender",                 limit: 4
    t.text     "description",            limit: 65535
    t.datetime "deleted_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "owner_type", limit: 255
    t.integer  "owner_id",   limit: 4
    t.integer  "provider",   limit: 4
    t.string   "link",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "videos", ["deleted_at"], name: "index_videos_on_deleted_at", using: :btree
  add_index "videos", ["owner_type", "owner_id"], name: "index_videos_on_owner_type_and_owner_id", using: :btree

end

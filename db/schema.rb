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

ActiveRecord::Schema.define(version: 20160804163345) do

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "phone",      limit: 255
    t.string   "address1",   limit: 255
    t.string   "address2",   limit: 255
    t.string   "city",       limit: 255
    t.string   "zipcode",    limit: 255
    t.integer  "country_id", limit: 4
    t.string   "state_name", limit: 255
    t.integer  "state_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.string   "provider",        limit: 255
    t.string   "uid",             limit: 255
    t.string   "username",        limit: 255
    t.string   "token",           limit: 255
    t.string   "secret",          limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "publishable_key", limit: 255
  end

  add_index "authentications", ["provider", "uid"], name: "index_authentications_on_provider_and_uid", using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.string   "state",            limit: 255
    t.integer  "performer_id",     limit: 4
    t.integer  "user_id",          limit: 4
    t.integer  "service_id",       limit: 4
    t.integer  "event_type_id",    limit: 4
    t.integer  "venue_type_id",    limit: 4
    t.integer  "address_id",       limit: 4
    t.string   "email",            limit: 255
    t.integer  "number_of_guests", limit: 4,     default: 1
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "special_info",     limit: 65535
    t.integer  "hours",            limit: 4,     default: 1
    t.integer  "total_cents",      limit: 4
    t.string   "currency",         limit: 255
    t.string   "last_ip_address",  limit: 255
    t.string   "token",            limit: 255
    t.string   "payment_state",    limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "bookings", ["deleted_at"], name: "index_bookings_on_deleted_at", using: :btree
  add_index "bookings", ["end_at"], name: "index_bookings_on_end_at", using: :btree
  add_index "bookings", ["performer_id"], name: "index_bookings_on_performer_id", using: :btree
  add_index "bookings", ["start_at"], name: "index_bookings_on_start_at", using: :btree
  add_index "bookings", ["state"], name: "index_bookings_on_state", using: :btree
  add_index "bookings", ["token"], name: "index_bookings_on_token", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "kind",        limit: 4,   default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "categories", ["kind"], name: "index_categories_on_kind", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "iso_name",        limit: 255
    t.string   "iso",             limit: 255
    t.string   "iso3",            limit: 255
    t.string   "name",            limit: 255
    t.integer  "numcode",         limit: 4
    t.boolean  "states_required",             default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "name",                limit: 255
    t.string   "month",               limit: 255
    t.string   "year",                limit: 255
    t.string   "cc_type",             limit: 255
    t.string   "last_digits",         limit: 255
    t.string   "customer_profile_id", limit: 255
    t.string   "payment_profile_id",  limit: 255
    t.boolean  "default",                         default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "credit_cards", ["deleted_at"], name: "index_credit_cards_on_deleted_at", using: :btree
  add_index "credit_cards", ["payment_profile_id"], name: "index_credit_cards_on_payment_profile_id", using: :btree
  add_index "credit_cards", ["user_id"], name: "index_credit_cards_on_user_id", using: :btree

  create_table "daily_schedules", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "wday",       limit: 4
    t.integer  "start_slot", limit: 4
    t.integer  "end_slot",   limit: 4
    t.boolean  "active",               default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "daily_schedules", ["active"], name: "index_daily_schedules_on_active", using: :btree
  add_index "daily_schedules", ["user_id"], name: "index_daily_schedules_on_user_id", using: :btree
  add_index "daily_schedules", ["wday"], name: "index_daily_schedules_on_wday", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "event_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "languages", force: :cascade do |t|
    t.string  "code",        limit: 255
    t.string  "name",        limit: 255
    t.string  "native_name", limit: 255
    t.boolean "active",                  default: false
  end

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

  create_table "payments", force: :cascade do |t|
    t.integer  "booking_id",           limit: 4
    t.integer  "amount_cents",         limit: 4
    t.integer  "fee_cents",            limit: 4
    t.integer  "total_cents",          limit: 4
    t.integer  "source_id",            limit: 4
    t.string   "source_type",          limit: 255
    t.integer  "payment_method_id",    limit: 4
    t.string   "state",                limit: 255
    t.string   "token",                limit: 255
    t.string   "response_code",        limit: 255
    t.string   "avs_response",         limit: 255
    t.string   "cvv_response_code",    limit: 255
    t.string   "cvv_response_message", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "payments", ["booking_id"], name: "index_payments_on_booking_id", using: :btree
  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
  add_index "payments", ["payment_method_id"], name: "index_payments_on_payment_method_id", using: :btree
  add_index "payments", ["source_id", "source_type"], name: "index_payments_on_source_id_and_source_type", using: :btree
  add_index "payments", ["state"], name: "index_payments_on_state", using: :btree
  add_index "payments", ["token"], name: "index_payments_on_token", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.string   "slug",       limit: 255
    t.boolean  "published",                default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree
  add_index "posts", ["published"], name: "index_posts_on_published", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.string   "perform_name",           limit: 255
    t.string   "phone_number",           limit: 255
    t.integer  "ethnicity",              limit: 4
    t.integer  "bust",                   limit: 4
    t.float    "height",                 limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.float    "weight",                 limit: 24
    t.string   "body_type",              limit: 255
    t.string   "experience_level",       limit: 255
    t.string   "social_security_number", limit: 255
    t.string   "education_level",        limit: 255
    t.boolean  "eligible_in_us",                     default: true
    t.string   "hear_from",              limit: 255
    t.string   "communing_plan",         limit: 255
  end

  add_index "profiles", ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "profiles_experiences", force: :cascade do |t|
    t.integer "profile_id",    limit: 4
    t.integer "experience_id", limit: 4
  end

  add_index "profiles_experiences", ["experience_id"], name: "index_profiles_experiences_on_experience_id", using: :btree
  add_index "profiles_experiences", ["profile_id"], name: "index_profiles_experiences_on_profile_id", using: :btree

  create_table "profiles_languages", force: :cascade do |t|
    t.integer "profile_id",  limit: 4
    t.integer "language_id", limit: 4
  end

  add_index "profiles_languages", ["language_id"], name: "index_profiles_languages_on_language_id", using: :btree
  add_index "profiles_languages", ["profile_id"], name: "index_profiles_languages_on_profile_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "reservations", ["end_at"], name: "index_reservations_on_end_at", using: :btree
  add_index "reservations", ["start_at"], name: "index_reservations_on_start_at", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

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

  create_table "states", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "abbr",       limit: 255
    t.integer  "country_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree

  create_table "testimonials", force: :cascade do |t|
    t.integer  "author_id",   limit: 4
    t.text     "text",        limit: 65535
    t.float    "rating",      limit: 24,    default: 0.0
    t.integer  "service_id",  limit: 4
    t.integer  "receiver_id", limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "testimonials", ["author_id"], name: "index_testimonials_on_author_id", using: :btree
  add_index "testimonials", ["receiver_id"], name: "index_testimonials_on_receiver_id", using: :btree
  add_index "testimonials", ["service_id"], name: "index_testimonials_on_service_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
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
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.date     "birth_date"
    t.boolean  "verified",                             default: false
    t.string   "referral_code",          limit: 255
    t.integer  "referrer_id",            limit: 4
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["referral_code"], name: "index_users_on_referral_code", using: :btree
  add_index "users", ["referrer_id"], name: "index_users_on_referrer_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "venue_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

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

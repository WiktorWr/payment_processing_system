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

ActiveRecord::Schema[7.2].define(version: 2024_10_27_170421) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "order_status", ["pending", "paid", "canceled"]
  create_enum "package_interval", ["day", "week", "month", "year"]
  create_enum "package_price_currency", ["PLN", "USD"]

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "package_id", null: false
    t.string "stripe_payment_id"
    t.enum "order_status", default: "pending", null: false, enum_type: "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_orders_on_package_id"
    t.index ["stripe_payment_id"], name: "index_orders_on_stripe_payment_id", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.enum "package_interval", default: "month", null: false, enum_type: "package_interval"
    t.enum "package_price_currency", default: "USD", null: false, enum_type: "package_price_currency"
    t.string "stripe_product_id", null: false
    t.string "stripe_price_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_packages_on_name", unique: true
    t.index ["stripe_price_id"], name: "index_packages_on_stripe_price_id", unique: true
    t.index ["stripe_product_id"], name: "index_packages_on_stripe_product_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "stripe_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true
  end

  add_foreign_key "orders", "packages"
  add_foreign_key "orders", "users"
end

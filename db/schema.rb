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

ActiveRecord::Schema[8.0].define(version: 2025_06_22_034927) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id", null: false
    t.bigint "tax_type_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "tax_amount", precision: 10, scale: 2, null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_invoice_items_on_created_at"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
    t.index ["tax_type_id"], name: "index_invoice_items_on_tax_type_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number", null: false
    t.string "client_name", null: false
    t.string "client_email"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.date "issue_date", null: false
    t.string "status", default: "emitida"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
    t.index ["issue_date"], name: "index_invoices_on_issue_date"
    t.index ["status"], name: "index_invoices_on_status"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock", default: 0
    t.integer "min_stock", default: 5
    t.text "description"
    t.boolean "active", default: true
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["category"], name: "index_products_on_category"
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "stock_histories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "old_stock", null: false
    t.integer "new_stock", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_stock_histories_on_created_at"
    t.index ["product_id"], name: "index_stock_histories_on_product_id"
  end

  create_table "tax_types", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "percentage", precision: 5, scale: 4, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_tax_types_on_active"
  end

  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoice_items", "tax_types"
  add_foreign_key "stock_histories", "products"
end

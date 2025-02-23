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

ActiveRecord::Schema.define(version: 20180226060150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ama_browse_nodes", primary_key: "browse_node_id", force: :cascade do |t|
    t.string "browse_node_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ama_product_items", primary_key: "asin", id: :string, force: :cascade do |t|
    t.bigint "upc"
    t.bigint "browse_node_id"
    t.string "title"
    t.string "studio"
    t.string "parent_asin"
    t.string "list_price_formated"
    t.string "ean"
    t.boolean "is_adult_product"
    t.string "brand"
    t.integer "package_qty"
    t.string "product_group"
    t.string "publisher"
    t.integer "brand_max_age"
    t.integer "brand_min_age"
    t.string "model"
    t.string "mpn"
    t.integer "num_of_items"
    t.string "detail_page_url"
    t.string "sm_image_url"
    t.string "mid_image_url"
    t.string "lrg_image_url"
    t.datetime "publication_date"
    t.datetime "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sales_rank"
    t.string "product_language"
  end

  create_table "ama_product_list_prices", force: :cascade do |t|
    t.string "asin"
    t.bigint "amount"
    t.string "currency_code"
    t.string "formated_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ama_top_sellers", force: :cascade do |t|
    t.string "asin"
    t.string "title"
    t.string "detail_page_url"
    t.string "product_group"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

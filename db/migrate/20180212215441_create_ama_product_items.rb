class CreateAmaProductItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ama_product_items, id:false, force: :cascade do |t|
      t.primary_key :asin
      t.bigint :upc
      t.bigint :browse_node_id
      t.string :title
      t.string :studio
      t.string :parent_asin
      t.string :brand
      t.integer :package_qty
      t.string :product_group
      t.string :publisher
      t.integer :brand_max_age
      t.integer :brand_min_age
      t.string :model
      t.string :mpn
      t.integer :num_of_items
      t.string :detail_page_url
      t.string :sm_image_url
      t.string :mid_image_url
      t.string :lrg_image_url
      t.datetime :publication_date
      t.datetime :release_date

      t.timestamps
    end
  end
end

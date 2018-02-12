class CreateAmaTopSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :ama_top_sellers do |t|
      t.bigint :asin
      t.string :title
      t.string :detail_page_url
      t.string :product_group
      t.boolean :is_active

      t.timestamps
    end
  end
end

class CreateAmaProductListPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :ama_product_list_prices do |t|
      t.string :asin
      t.bigint :amount
      t.string :currency_code
      t.string :formated_price

      t.timestamps
    end
  end
end

class AddProductLanguageToAmaProductItems < ActiveRecord::Migration[5.1]
  def change
    add_column :ama_product_items, :product_language, :string
  end
end

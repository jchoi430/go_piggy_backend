class AmaTopSeller < ApplicationRecord
  belongs_to :ama_product_items, foreign_key: :asin, class_name: 'AmaProductItem'
end

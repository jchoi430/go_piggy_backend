class AmaProductItem < ApplicationRecord
  has_one :ama_top_seller, foreign_key: :asin, class_name: 'AmaTopSeller'
  has_one :ama_product_list_price, foreign_key: :asin, class_name: 'AmaProductListPrice'
  belongs_to :ama_browse_node, foreign_key: :browse_node_id, class_name: 'AmaBrowseNode'
end

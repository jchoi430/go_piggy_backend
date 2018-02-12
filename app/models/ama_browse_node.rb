class AmaBrowseNode < ApplicationRecord
  has_many :ama_product_items, foreign_key: :browse_node_id, class_name: "AmaProductItem", dependent: :nullify
end

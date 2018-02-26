class AmaProductItems < ActiveRecord::Migration[5.1]
  def change
    add_column :ama_product_items, :sales_rank, :integer
  end
end

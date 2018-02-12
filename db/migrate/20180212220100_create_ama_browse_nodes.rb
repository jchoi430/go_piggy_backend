class CreateAmaBrowseNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :ama_browse_nodes, id:false, force: :cascade do |t|
      t.primary_key :browse_node_id
      t.string :browse_node_name

      t.timestamps
    end
  end
end

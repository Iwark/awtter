class AddServerIdToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :server_id, :integer, default: 1
    add_index :groups, :server_id
  end
end

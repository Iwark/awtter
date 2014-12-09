class AddTargetIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :target_id, :integer
  end
end

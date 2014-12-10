class AddIndexToAccounts < ActiveRecord::Migration
  def change
    add_index :accounts, :target_id
  end
end

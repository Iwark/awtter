class RemoveTargetFromAccounts < ActiveRecord::Migration
  def change
	remove_column :accounts, :target
  end
end

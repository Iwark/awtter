class AddAutoRefollowToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_refollow, :boolean, default: false
  end
end

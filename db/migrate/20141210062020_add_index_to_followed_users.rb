class AddIndexToFollowedUsers < ActiveRecord::Migration
  def change
    add_index :followed_users, :account_id
    add_index :followed_users, :status
  end
end

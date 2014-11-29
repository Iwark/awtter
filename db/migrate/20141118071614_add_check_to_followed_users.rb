class AddCheckToFollowedUsers < ActiveRecord::Migration
  def change
    add_column :followed_users, :checked, :boolean
    add_column :followed_users, :status, :integer
  end
end

class ChangeUserIdTypeInFollowedUsers < ActiveRecord::Migration
  def up
    change_column :followed_users, :user_id, :string
  end

  def down
    change_column :followed_users, :user_id, :integer
  end
end

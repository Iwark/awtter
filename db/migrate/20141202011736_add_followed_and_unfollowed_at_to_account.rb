class AddFollowedAndUnfollowedAtToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :followed_at, :datetime
    add_column :accounts, :unfollowed_at, :datetime
  end
end

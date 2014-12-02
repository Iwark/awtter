class AddFollowedAndUnfollowedAtToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :followed_at, :datetime, default: DateTime.now
    add_column :accounts, :unfollowed_at, :datetime, default: DateTime.now
  end
end

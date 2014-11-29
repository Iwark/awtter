class AddFollowerNumToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :follower_num, :integer, default: 0
  end
end

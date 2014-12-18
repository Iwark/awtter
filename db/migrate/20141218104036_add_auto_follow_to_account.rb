class AddAutoFollowToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_follow, :boolean, default: true
    add_column :accounts, :auto_unfollow, :boolean, default: true
  end
end

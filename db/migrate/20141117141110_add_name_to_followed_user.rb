class AddNameToFollowedUser < ActiveRecord::Migration
  def change
    add_column :followed_users, :name, :string
  end
end

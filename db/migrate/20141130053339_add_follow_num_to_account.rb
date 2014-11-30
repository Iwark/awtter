class AddFollowNumToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :follow_num, :integer, default: 0
  end
end

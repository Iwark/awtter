class AddAccountIdToRetweet < ActiveRecord::Migration
  def change
    add_column :retweets, :account_id, :integer, default: 0
  end
end

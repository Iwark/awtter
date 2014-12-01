class AddStatusToRetweet < ActiveRecord::Migration
  def change
    add_column :retweets, :status, :integer, default: 0
    add_index  :retweets, :status
  end
end

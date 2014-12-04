class AddAutoTweetToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_tweeted_at, :datetime, default: DateTime.now
    add_column :accounts, :auto_tweet, :boolean, default: false
  end
end

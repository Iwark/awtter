class ChangeTweetIdTypeInTweets < ActiveRecord::Migration
  def up
    change_column :tweets, :tweet_id, :string
  end

  def down
    change_column :tweets, :tweet_id, :integer
  end
end
class AddAutoRetweetToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_retweet, :boolean, default: false
    add_column :accounts, :auto_retweeted_at, :datetime, default: DateTime.now
  end
end

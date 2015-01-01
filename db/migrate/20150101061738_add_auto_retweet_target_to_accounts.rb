class AddAutoRetweetTargetToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_retweet_target, :string
    add_column :accounts, :target_auto_retweeted_at, :datetime, default: DateTime.now
  end
end

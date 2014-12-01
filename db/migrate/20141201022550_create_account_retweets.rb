class CreateAccountRetweets < ActiveRecord::Migration
  def change
    create_table :account_retweets do |t|
      t.integer :account_id
      t.integer :retweet_id

      t.timestamps
    end
  end
end

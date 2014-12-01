class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.string :url
      t.integer :group_id
      t.datetime :start_at
      t.integer :interval
      t.integer :frequency

      t.timestamps

      t.index :group_id
    end
  end
end

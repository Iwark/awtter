class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :api_key
      t.string :api_secret
      t.string :access_token
      t.string :access_token_secret
      t.string :target
      t.string :description
      t.integer :group_id

      t.timestamps

      t.index :group_id
    end
  end
end

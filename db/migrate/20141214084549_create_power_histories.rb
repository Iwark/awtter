class CreatePowerHistories < ActiveRecord::Migration
  def change
    create_table :power_histories do |t|
      t.integer :followers_sum

      t.timestamps
    end
  end
end

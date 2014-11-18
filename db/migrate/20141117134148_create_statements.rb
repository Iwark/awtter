class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string :contents
      t.integer :priority
      t.integer :pattern

      t.timestamps
    end
  end
end

class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end

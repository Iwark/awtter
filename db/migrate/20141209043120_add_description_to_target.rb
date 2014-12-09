class AddDescriptionToTarget < ActiveRecord::Migration
  def change
    add_column :targets, :description, :string
  end
end

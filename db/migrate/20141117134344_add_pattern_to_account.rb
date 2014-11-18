class AddPatternToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :pattern, :integer
  end
end

class SetDependentNotNull < ActiveRecord::Migration
  def change
    change_column :dependencies, :dependent, :string, :null => false
  end
end

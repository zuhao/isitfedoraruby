class RemoveNameColumnFromDependencies < ActiveRecord::Migration
  def change
    change_table :dependencies do |t|
      t.remove :name
      t.remove :version
    end
  end
end

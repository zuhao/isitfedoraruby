class AddDependencyColumn < ActiveRecord::Migration
  def change
    change_table :dependencies do |t|
      t.references :package, polymorphic: true
    end
  end
end

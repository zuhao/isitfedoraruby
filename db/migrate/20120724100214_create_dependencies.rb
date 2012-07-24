class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.string :name
      t.string :version
      t.string :environment
      t.string :dependent
      t.string :dependent_version
      t.timestamps
    end
  end
end

class CreateRpmSpecs < ActiveRecord::Migration
  def change
    create_table :rpm_specs do |t|
      t.string :name, :null => false 
      t.string :description
      t.string :fedorapkg
      t.string :type
      t.string :rpm_version
      t.string :patch_version
      t.string :patch_summary
      t.integer :comments_count => {:default => 0}
      t.integer :works_count => {:default => 0}
      t.references :gem_specs => {:default => nil}
      t.timestamps
    end
  end
end

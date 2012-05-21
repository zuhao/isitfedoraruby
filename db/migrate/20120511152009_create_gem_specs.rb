class CreateGemSpecs < ActiveRecord::Migration
  def change
    create_table :gem_specs do |t|
      t.string :name, :null => false
      t.string :description
      t.string :rubygems
      t.string :type
      t.string :version
      t.boolean :has_rpm
      t.integer :comments_count => {:default => 0}
      t.integer :want_count => {:default => 0}
      t.references :rpm_specs => {:default => nil}
      t.timestamps
    end
  end
end

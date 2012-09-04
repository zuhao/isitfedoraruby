class AddBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.string :name
      t.string :bz_id
      t.references :fedora_rpm
      t.boolean :is_review
      t.timestamps
    end
  end
end

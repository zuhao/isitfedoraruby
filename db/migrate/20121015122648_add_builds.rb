class AddBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :name
      t.string :build_id
      t.references :fedora_rpm
      t.timestamps
    end
  end
end

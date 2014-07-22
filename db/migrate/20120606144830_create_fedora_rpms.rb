class CreateFedoraRpms < ActiveRecord::Migration
  def change
    create_table :fedora_rpms do |t|
      t.string :name, null: false
      t.string :description
      t.string :homepage
      t.string :version
      t.string :latest_patch
      t.string :patch_summary
      t.references ruby_gem: { default: nil }
      t.timestamps
    end
  end
end

class CreateRpmVersions < ActiveRecord::Migration
  def self.up
    create_table :rpm_versions do |t|
      t.references :fedora_rpm
      t.string :rpm_version
      t.string :fedora_version

      t.timestamps
    end

    remove_column :fedora_rpms, :version
  end

  def self.down
    drop_table :rpm_versions
    add_column :fedora_rpms, :version, :string
  end
end

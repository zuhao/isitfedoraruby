class AddCommitsToFedoraRpms < ActiveRecord::Migration
  def self.up
    add_column :fedora_rpms, :commits, :int
  end

  def self.down
    remove_column :fedora_rpms, :commits
  end
end

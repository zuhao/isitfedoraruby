class RemoveLastCommitShaFromFedoraRpm < ActiveRecord::Migration
  def change
    remove_column :fedora_rpms, :last_commit_sha
  end
end

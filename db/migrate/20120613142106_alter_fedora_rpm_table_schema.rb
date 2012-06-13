class AlterFedoraRpmTableSchema < ActiveRecord::Migration
  def change
    change_table :fedora_rpms do |t|
      t.remove :description
      t.remove :version
      t.rename :homepage, :git_url
      t.rename :patch_summary, :last_commit_message
      t.string :author
      t.string :last_committer
      t.datetime :last_commit_date
      t.string :last_commit_sha
    end
  end
end

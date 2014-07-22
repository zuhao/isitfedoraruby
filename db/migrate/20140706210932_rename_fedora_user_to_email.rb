class RenameFedoraUserToEmail < ActiveRecord::Migration
  def change
    rename_column :fedora_rpms, :fedora_user, :owner_email
  end
end

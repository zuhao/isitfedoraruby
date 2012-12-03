class AddFedoraUserColumnToFedoraRpms < ActiveRecord::Migration
  def change
    add_column :fedora_rpms, :fedora_user, :string
  end
end

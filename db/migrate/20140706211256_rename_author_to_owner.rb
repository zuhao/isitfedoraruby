class RenameAuthorToOwner < ActiveRecord::Migration
  def change
    rename_column :fedora_rpms, :author, :owner
  end
end

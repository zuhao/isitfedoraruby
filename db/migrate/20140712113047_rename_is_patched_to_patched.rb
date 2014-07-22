class RenameIsPatchedToPatched < ActiveRecord::Migration
  def change
    rename_column :rpm_versions, :is_patched, :patched
  end
end

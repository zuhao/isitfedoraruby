class MarkPatchedRpms < ActiveRecord::Migration
  def change
    change_table :rpm_versions do |t|
      t.boolean :is_patched
    end
  end
end

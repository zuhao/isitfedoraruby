class RemoveLastPatchColumnFromFedoraRpm < ActiveRecord::Migration
  def change
    change_table :fedora_rpms do |t|
      t.remove :lastest_patch
    end
  end
end

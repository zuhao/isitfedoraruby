class ModifyFedoraRpm < ActiveRecord::Migration
  def change
    change_table :fedora_rpms do |t|
      t.string :homepage
      t.string :version
    end
  end
end

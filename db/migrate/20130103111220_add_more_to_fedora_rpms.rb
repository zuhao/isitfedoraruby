class AddMoreToFedoraRpms < ActiveRecord::Migration
  def change
    add_column :fedora_rpms, :summary, :string
    add_column :fedora_rpms, :description, :string
  end
end

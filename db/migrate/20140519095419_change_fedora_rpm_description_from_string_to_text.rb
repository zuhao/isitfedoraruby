class ChangeFedoraRpmDescriptionFromStringToText < ActiveRecord::Migration
  def change
    change_column :fedora_rpms, :description, :text
    change_column :fedora_rpms, :summary, :text
    change_column :ruby_gems, :description, :text
  end
end

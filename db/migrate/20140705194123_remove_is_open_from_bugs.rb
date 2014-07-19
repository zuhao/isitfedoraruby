class RemoveIsOpenFromBugs < ActiveRecord::Migration
  def change
    remove_column :bugs, :is_open, :boolean
  end
end

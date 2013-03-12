class AddIsOpenToBugs < ActiveRecord::Migration
  def change
    add_column :bugs, :is_open, :boolean
  end
end

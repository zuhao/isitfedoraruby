class AddLastUpdatedToBugs < ActiveRecord::Migration
  def change
    add_column :bugs, :last_updated, :string
  end
end

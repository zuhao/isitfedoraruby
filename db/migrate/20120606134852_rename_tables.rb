class RenameTables < ActiveRecord::Migration
  
  def change
	rename_table :gem_specs, :gems
	rename_table :rpm_specs, :rpms
  end

end

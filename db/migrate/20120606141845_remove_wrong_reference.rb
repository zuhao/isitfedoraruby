class RemoveWrongReference < ActiveRecord::Migration
  
  def change
  	remove_column :gem_comments, :gem_specs_id
  	remove_column :rpm_comments, :rpm_specs_id
  end
  
end

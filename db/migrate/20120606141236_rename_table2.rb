class RenameTable2 < ActiveRecord::Migration
  
  def change
  	change_table :gem_comments do |t|
  	  t.references :gem
  	end

  	change_table :rpm_comments do |t|
  	  t.references :rpm
  	end
  end
  
end

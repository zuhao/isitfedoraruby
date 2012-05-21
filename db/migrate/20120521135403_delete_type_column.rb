class DeleteTypeColumn < ActiveRecord::Migration
  def change
  	change_table :gem_specs do |t|
  	  t.remove :type
  	end

  	change_table :rpm_specs do |t|
  	  t.remove :type
  	end
  end
end

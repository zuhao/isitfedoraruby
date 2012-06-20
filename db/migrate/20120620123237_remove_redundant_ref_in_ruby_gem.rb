class RemoveRedundantRefInRubyGem < ActiveRecord::Migration
  def change
    change_table :ruby_gems do |t|
      t.remove :fedora_rpm_id
    end
  end
end

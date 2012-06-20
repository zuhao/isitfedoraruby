class AddReferenceToRubyGem < ActiveRecord::Migration
  def change
    change_table :ruby_gems do |t|
      t.references :fedora_rpm
    end

    change_table :fedora_rpms do |t|
      t.references :ruby_gem
    end
  end
end

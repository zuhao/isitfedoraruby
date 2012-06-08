class CreateRubyGems < ActiveRecord::Migration
  def change
    create_table :ruby_gems do |t|
      t.string :name, :null => false
      t.string :description
      t.string :homepage
      t.string :version
      t.boolean :has_rpm
      t.references :fedora_rpm => {:default => nil}
      t.timestamps
    end
  end

end

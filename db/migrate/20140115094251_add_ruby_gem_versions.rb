class AddRubyGemVersions < ActiveRecord::Migration
  def change
    create_table :gem_versions do |t|
      t.string :gem_version
      t.belongs_to :ruby_gem
      t.timestamps
    end
  end
end

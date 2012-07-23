class AddSourceUriColumnToRubyGem < ActiveRecord::Migration
  def change
    change_table :ruby_gems do |t|
      t.string :source_uri
    end

    change_table :fedora_rpms do |t|
      t.rename :git_url, :source_uri
    end
  end
end

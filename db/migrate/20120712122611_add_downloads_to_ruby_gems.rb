class AddDownloadsToRubyGems < ActiveRecord::Migration
  def self.up
    add_column :ruby_gems, :downloads, :int
  end

  def self.down
    remove_column :ruby_gems, :downloads
  end
end

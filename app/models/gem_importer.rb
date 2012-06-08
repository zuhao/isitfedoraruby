require 'rubygems'
require "rubygems/spec_fetcher"

class GemImporter
  
  RUBYGEMS_URI = 'http://rubygems.org/'

  def self.import
    Gem::SpecFetcher.fetcher.list[URI.parse(RUBYGEMS_URI)].each do |gem|
      RubyGem.new_from_gem_tuple(gem)
    end
  rescue Exception => ex 
      puts ex.message
  end

end
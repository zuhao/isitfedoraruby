class GemSpec < ActiveRecord::Base

  has_one :rpm_spec, :dependent => :destroy
  has_many :gem_comment, :dependent => :destroy, :order => 'created_at desc'

  def self.new_from_gem_tuple(gem_tuple)
  	f = find_or_initialize_by_name(gem_tuple[0])
  	if f.new_record?
  	  require 'rubygems'
  	  spec = Gem::SpecFetcher.fetcher.fetch_spec(gem_tuple, URI.parse(GemImporter::RUBYGEMS_URI))
  	  f.description = spec.description.to_s
  	  f.rubygems = spec.homepage.to_s
  	  f.version = spec.version.to_s
  	  f.has_rpm = false
      f.save!
  	  logger.info("Gem #{f.name} imported")
  	else
  	  logger.info("Gem #{f.name} already existed")
  	end
  rescue => e
  	logger.info("Could not create gem spec for #{gem_tuple[0]}")
  end

private
  
  validates :name, :uniqueness => true
  validates :name, :presence => true

end

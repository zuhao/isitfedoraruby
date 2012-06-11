class RubyGem < ActiveRecord::Base
  
  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comment, :dependent => :destroy, :order => 'created_at desc'
  scope :popular, :order => 'gem_comments_count desc'

  def self.new_from_gem_tuple(gem_tuple)
    require 'rubygems'

    f = find_or_initialize_by_name(gem_tuple[0])
    if f.new_record?
      spec = Gem::SpecFetcher.fetcher.fetch_spec(gem_tuple, URI.parse(GemImporter::RUBYGEMS_URI))
      f.description = spec.description.to_s
      f.homepage = spec.homepage.to_s
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

  def gem_name
    self.name
  end

  def has_rpm?
    self.has_rpm
  end

  def wantedness
    total = GemComment.count
    total = 1 if total == 0
    GemComment.wanted.count * 100 / total
  end

private
  
  validates_uniqueness_of :name
  validates_presence_of :name

end

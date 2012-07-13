class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comments, :dependent => :destroy, :order => 'created_at desc'
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
    logger.info("Could not import #{gem_tuple[0]}")
  end

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    if search == nil || search.blank?
      self
    else
      self.where("name LIKE ?", search.strip)
    end
  end

  def gem_name
    self.name
  end

  def has_rpm?
    self.has_rpm
  end

  def wantedness
    total = self.gem_comments.count
    total = 1 if total == 0
    self.gem_comments.wanted.count * 100 / total
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

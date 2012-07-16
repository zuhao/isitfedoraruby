class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comments, :dependent => :destroy, :order => 'created_at desc'
  scope :popular, :order => 'gem_comments_count desc'

  def version_in_fedora(fedora_version)
    return nil if fedora_rpm.nil?
    fedora_rpm.version_for(fedora_version)
  end

  def upto_date_in_fedora?
    return false if fedora_rpm.nil?
    fedora_rpm.upto_date?
  end

  def self.new_from_name(gem_name)
    require 'rubygems'

    f = find_or_initialize_by_name(gem_name)
    if f.new_record?
      metadata = JSON.parse(Curl::Easy.http_get(GemImporter::RUBYGEMS_URI + GemImporter::API_ENDPOINT + f.name + ".json").body_str)
      f.description = metadata['info'].to_s
      f.homepage = metadata['homepage_uri'].to_s
      f.version = metadata['version'].to_s
      f.downloads = metadata['downloads']
      f.has_rpm = false
      f.save!
      logger.info("Gem #{f.name} imported")
    else
      logger.info("Gem #{f.name} already existed")
    end

    return f
  rescue => e
    logger.info("Could not import #{gem_name} due to error #{e}")
    return nil

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

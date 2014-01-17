require 'gems'

class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :dependencies, -> { order 'created_at desc' }, :as => :package,
           :dependent => :destroy
  has_many :historical_gems, :foreign_key => :gem_id
  has_many :gem_versions, :dependent => :destroy
  scope :most_popular, -> { order 'downloads desc' }

  def to_param
    name
  end

  def self.load_or_create(name)
    gem = RubyGem.where(name: name).first_or_initialize
    return unless gem.on_rubygems?
    gem.save!
    gem
  end

  def on_rubygems?
    metadata = Gems.info(name)
    # If gem is not found on RubyGems.org, a string will be returned, saying
    #   "This rubygem could not be found."
    not metadata.is_a?(String)
  end

  def retrieve_metadata
    metadata = Gems.info(name)
    return if metadata.is_a?(String)

    self.description = metadata['info'].to_s
    self.homepage = metadata['homepage_uri'].to_s
    self.source_uri = metadata['source_code_uri'].to_s
    self.version = metadata['version'].to_s
    self.downloads = metadata['downloads'].to_i

    # pull and store dependencies
    self.dependencies.clear
    metadata['dependencies'].each do |environment, dependencies|
      dependencies.each do |dep|
        d = Dependency.new
        d.environment = environment
        d.dependent = dep['name']
        d.dependent_version = dep['requirements']
        self.dependencies << d
      end unless dependencies.nil? || dependencies.empty?
    end unless metadata['dependencies'].nil?
  end

  def retrieve_rpm
    rpm_name = 'rubygem-' + self.name
    self.fedora_rpm = FedoraRpm.where(name: rpm_name).first
    self.has_rpm = true unless self.fedora_rpm.nil?
  end

  def retrieve_versions
    self.gem_versions.clear
    versions = Gems.versions self.name
    versions.each do |v|
      ver = GemVersion.new(gem_version: v['number'])
      self.gem_versions << ver
    end unless versions.is_a? String
  end

  def update_from_source
    retrieve_metadata
    retrieve_rpm
    retrieve_versions
    self.updated_at = Time.now
    save!
  rescue Exception => e
    puts "Updating #{name} failed due to #{e.to_s}"
  end

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    s = search.gsub(/rubygem-/,'')
    if s == nil || s.blank?
      self
    else
      self.where('name LIKE ?', s.strip)
    end
  end

  def gem_name
    self.name
  end

  def has_rpm?
    self.has_rpm
  end

  def version_in_fedora(fedora_version)
    return nil if self.fedora_rpm.nil?
    self.fedora_rpm.version_for(fedora_version)
  end

  def upto_date_in_fedora?
    return false if self.fedora_rpm.nil?
    self.fedora_rpm.upto_date?
  end

  def dependency_packages
    self.dependencies.collect { |d|
      RubyGem.where(name: d.dependent).first
    }.compact
  end

  def dependent_packages
    Dependency.where(dependent: self.name).to_a.collect { |d| d.package }
  end

  def uri_for_version(version)
    "http://rubygems.org/gems/#{self.name}-#{self.version}.gem"
  end

  def local_gem_for_version(version)
    "#{Rails.root}/public/rpmbuild/SOURCES/#{self.name}-#{self.version}.gem"
  end

  def download
    download_version(self.version)
  end

  def download_version(version)
    local_gem = local_gem_for_version(version)
    return if File.exists?(local_gem) # just return if version already downloaded
    c = Curl::Easy.new(uri_for_version(version))
    c.follow_location = true
    result = c.http_get
    result = c.body_str.force_encoding('UTF-8')
    File.open(local_gem, "w") { |f|
      f.write result
    }
  end

  def gem2rpm
    version2rpm(self.version)
  end

  def version2rpm(version)
    rpm_spec_file = "#{Rails.root}/public/rpmbuild/SPECS/rubygem-#{name}-#{version}.spec"
    return rpm_spec_file if File.exists?(rpm_spec_file) # just return if already built

    spec = `/usr/bin/gem2rpm #{local_gem_for_version(version)}`
    File.open(rpm_spec_file, "w") { |f|
      f.write spec
    }
    rpm_spec_file
  end

  def description_string
    if self.description.blank?
      "#{gem_name} does not have a description yet"
    else
      self.description
    end
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

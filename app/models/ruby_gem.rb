require 'gems'

class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :dependencies, :as => :package, :dependent => :destroy, :order => 'created_at desc'
  scope :most_wanted, { :joins => 'INNER JOIN gem_comments ON gem_comments.ruby_gem_id = ruby_gems.id',
                        :conditions => 'gem_comments.want_it = "t"',
                        :group => 'ruby_gems.id',
                        :order => 'count(gem_comments.id) desc' }
  scope :most_popular, :order => 'downloads desc'

  # FIXME version metadata should be stored in local db
  attr_accessor :versions

  def to_param
    name
  end

  def self.load_or_create(name)
    gem = RubyGem.find_by_name(name)
    if gem.nil?
      gem = RubyGem.new
      gem.name = name
      return nil unless gem.on_rubygems?
      gem.save!
    end
    gem
  end

  def on_rubygems?
    # use RubyGems.org's API wrapper to get metadata
    metadata = Gems.info(name)
    return metadata != false
  end

  def retrieve_metadata
    # use RubyGems.org's API wrapper to get metadata
    metadata = Gems.info(name)
    return if !metadata || metadata.nil?
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
    self.fedora_rpm = FedoraRpm.find_by_name(rpm_name)
    self.has_rpm = true unless self.fedora_rpm.nil?
  end

  def retrieve_versions
    Gems.versions self.name
  end

  def update_from_source
    retrieve_metadata
    retrieve_rpm
    self.updated_at = Time.now
    save!
  end

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    s = search.gsub(/rubygem-/,'')
    if s == nil || s.blank?
      self
    else
      self.where("name LIKE ?", s.strip)
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

  def wanted_count
    self.gem_comments.wanted.count
  end

  def version_in_fedora(fedora_version)
    return nil if fedora_rpm.nil?
    fedora_rpm.version_for(fedora_version)
  end

  def upto_date_in_fedora?
    return false if fedora_rpm.nil?
    fedora_rpm.upto_date?
  end

  def dependency_packages
    self.dependencies.collect { |d|
      RubyGem.find_by_name(d.dependent)
    }.compact
  end

  def dependent_packages
    Dependency.find_all_by_dependent(self.name).collect { |d|
      d.package
    }
  end

  def uri_for_version(version)
    "http://rubygems.org/gems/#{name}-#{version}.gem"
  end

  def local_gem_for_version(version)
    "#{Rails.root}/public/rpmbuild/SOURCES/#{name}-#{version}.gem"
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

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

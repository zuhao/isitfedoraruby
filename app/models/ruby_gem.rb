require 'gems'

class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :dependencies, :as => :package, :dependent => :destroy, :order => 'created_at desc'
  scope :most_wanted, :joins => :gem_comments, :group => 'gem_comments.ruby_gem_id',
        :order => 'count(gem_comments.want_it) desc', :having => 'gem_comments.want_it = "t"'
  scope :most_popular, :order => 'downloads desc'

  def to_param
    name
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

  def update_from_source
    retrieve_metadata
    retrieve_rpm
    self.updated_at = Time.now
    save!
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

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

require 'gems'

class RubyGem < ActiveRecord::Base

  has_one :fedora_rpm, :dependent => :destroy
  has_many :gem_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :dependencies, :as => :package, :dependent => :destroy, :order => 'created_at desc'
  scope :popular, :order => 'gem_comments_count desc'

  def self.new_from_name(gem_name)
    f = find_or_initialize_by_name(gem_name)

    # use RubyGems.org's API wrapper to get metadata
    metadata = Gems.info(f.name)
    f.description = metadata['info'].to_s
    f.homepage = metadata['homepage_uri'].to_s
    f.source_uri = metadata['source_code_uri'].to_s
    f.version = metadata['version'].to_s
    f.downloads = metadata['downloads'].to_i
    f.has_rpm = false

    # pull and store dependencies
    f.dependencies.clear
    metadata['dependencies'].each do |environment, dependencies|
      unless dependencies.empty?
        dependencies.each do |dep|
          d = Dependency.new
          d.environment = environment
          d.dependent = dep['name']
          d.dependent_version = dep['requirements']
          f.dependencies << d
        end
      end
    end

    f.save!
    puts "Gem #{f.name} imported"
  rescue => e
    puts "Could not import #{gem_name} due to error #{e}"
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

  def get_gem_dependencies
    dep = []
    self.dependencies.each do |d|
      dep << { :id => RubyGem.find_by_name(d.dependent).id,
               :name => d.dependent,
               :version => d.dependent_version,
               :environment => d.environment }
    end
    return dep
  end

  def wantedness
    total = self.gem_comments.count
    total = 1 if total == 0
    self.gem_comments.wanted.count * 100 / total
  end

  def version_in_fedora(fedora_version)
    return nil if fedora_rpm.nil?
    fedora_rpm.version_for(fedora_version)
  end

  def upto_date_in_fedora?
    return false if fedora_rpm.nil?
    fedora_rpm.upto_date?
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

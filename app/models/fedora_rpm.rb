require 'versionomy'

class FedoraRpm < ActiveRecord::Base

  FEDORA_VERSIONS = {'rawhide'   => 'master',
                     'Fedora 17' => 'f17',
                     'Fedora 16' => 'f16',
                     'Fedora 15' => 'f15'}

  belongs_to :ruby_gem
  has_many :rpm_versions, :dependent => :destroy
  has_many :rpm_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  scope :popular, :order => 'rpm_comments_count desc'

  def versions
    rpm_versions.collect { |rv| rv.rpm_version + " (" + rv.fedora_version + ")" }.join(", ")
  end

  def version_for(fedora_version)
    rv = rpm_versions.find { |rv| rv.fedora_version == fedora_version }
    return nil if rv.nil?
    rv.rpm_version
  end

  def upto_date?
    rv = rpm_versions.find { |rv| rv.fedora_version == 'rawhide' }
    return false if rv.nil? || ruby_gem.nil?
    Versionomy.parse(rv.rpm_version) >= Versionomy.parse(ruby_gem.version)
  end

  def self.new_from_name(rpm_name)
    f = find_or_initialize_by_name(rpm_name)
    gem_name = rpm_name.gsub(/rubygem-/,'')
    f.ruby_gem = RubyGem.find_or_initialize_by_name(gem_name)
    f.ruby_gem.has_rpm = true
    f.ruby_gem.save
    f.source_uri = "git://pkgs.fedoraproject.org/#{rpm_name}.git"

    begin
      # parse commit log with nokogiri to determine how many commits there are
      git_log = URI.parse("#{RpmImporter::GIT_LOG_URI};p=#{rpm_name}.git").read
      doc = Nokogiri::HTML(git_log)
      f.commits = doc.xpath("//a[@class='title']").size

      FEDORA_VERSIONS.each do |version_title, version_git|
        spec_url = "#{RpmImporter::RPM_SPEC_URI};p=#{rpm_name}.git;f=#{rpm_name}.spec;hb=refs/heads/#{version_git}"
        puts "Reading spec from #{spec_url}"
        rpm_spec = URI.parse(spec_url).read

        rpm_version = rpm_spec.scan(/\nVersion: .*\n/).first.split.last
        rv = RpmVersion.new
        rv.rpm_version = rpm_version
        rv.fedora_version = version_title
        f.rpm_versions << rv
        if version_title == 'rawhide'
          f.homepage = rpm_spec.scan(/\nURL: .*\n/).first.split.last
        end
      end
      # TODO: more info can be extracted
    rescue OpenURI::HTTPError
      # some rpms do not have spec file
    rescue NoMethodError
      # some spec files do not have Version or URL
    end

    f.save!
    puts "Rpm #{rpm_name} imported"
  rescue => e
    puts "Could not import #{rpm_name} due to error #{e}"
  end

  def rpm_name
    self.name
  end

  def works?
    has_no_failure_comments? && has_working_comments?
  end

  def get_rpm_dependencies
    dep = []
    self.ruby_gem.dependencies.each do |d|
      rpm_name = "rubygem-#{d.dependent}"
      dep << { :id => FedoraRpm.find_by_name(rpm_name).id,
               :name => rpm_name,
               :version => d.dependent_version,
               :environment => d.environment }
    end
    return dep
  end

  def hotness
    total = self.rpm_comments.count
    total = 1 if total == 0
    self.rpm_comments.working.count * 100 / total
  end

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    if search == nil || search.blank?
      self
    else
      self.where("name LIKE ?", 'rubygem-' + search.strip)
    end
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

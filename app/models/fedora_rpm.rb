require 'versionomy'

class FedoraRpm < ActiveRecord::Base

  FEDORA_VERSIONS = {'rawhide'   => 'master',
                     'Fedora 18' => 'f18',
                     'Fedora 17' => 'f17',
                     'Fedora 16' => 'f16',
                     'Fedora 15' => 'f15'}

  belongs_to :ruby_gem
  has_many :rpm_versions, :dependent => :destroy
  has_many :rpm_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  has_many :dependencies, :as => :package, :dependent => :destroy, :order => 'created_at desc'
  scope :popular, :order => 'rpm_comments_count desc'

  def to_param
    name
  end

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
    return true if ruby_gem.version == nil
    Versionomy.parse(rv.rpm_version) >= Versionomy.parse(ruby_gem.version)
  end

  def retrieve_commits
    begin
      puts "Importing rpm #{name} commits"
      # parse commit log with nokogiri to determine how many commits there are
      log_uri = RpmImporter::BASE_URI + name + '.git/log/'
      git_log = URI.parse(log_uri).read
      doc = Nokogiri::HTML(git_log)
      self.commits = doc.xpath("//tr/td[@class='commitgraph']").select { |x| x.text == '* '}.size
    rescue Exception => e
      puts "Could not retrieve commits for #{name}"
    end
  end

  def retrieve_versions
    puts "Importing rpm #{name} versions"
    self.rpm_versions.clear
    self.dependencies.clear
    FEDORA_VERSIONS.each do |version_title, version_git|
      spec_url = "#{RpmImporter::BASE_URI}#{name}.git/plain/#{name}.spec?h=#{version_git}"
      puts "Reading spec from #{spec_url}"
      begin
        rpm_spec = URI.parse(spec_url).read

        rpm_version = rpm_spec.scan(/\nVersion: .*\n/).first.split.last
        if !version_valid?(rpm_version)
          if rpm_version.include?('%{majorver}')
            rpm_version = rpm_spec.scan(/%global majorver .*\n/).first.split.last
          else
            rpm_version = nil
          end
        end
        rv = RpmVersion.new
        rv.rpm_version = rpm_version
        rv.fedora_version = version_title
        self.rpm_versions << rv
        if version_title == 'rawhide'
          self.homepage = rpm_spec.scan(/\nURL: .*\n/).first.split.last

          rpm_spec.split("\n").each { |line|
            mr = line.match(/^Requires:\s*rubygem\(([^\s]*)\)\s*(.*)$/)
            if mr.nil?
              mr = line.match(/^BuildRequires:\s*rubygem\(([^\s]*)\)\s*(.*)$/)
            end
            if mr
              d = Dependency.new
              d.dependent = mr.captures.first
              d.dependent_version = mr.captures.last
              self.dependencies << d
            end
          }
        end
      rescue Exception => e
        puts "Could not retrieve version of #{name} for #{version_title}"
      end
    end
  end

  def version_valid?(version)
    Versionomy.parse(version)
    true
  rescue Versionomy::Errors::ParseError
    false
  end

  def retrieve_gem
    gem_name = name.gsub(/rubygem-/,'')
    self.ruby_gem = RubyGem.find_or_initialize_by_name(gem_name)
    self.ruby_gem.has_rpm = true
  end

  def update_from_source
    retrieve_commits
    retrieve_versions
    retrieve_gem
    self.updated_at = Time.now
    save!
  end

  def rpm_name
    self.name
  end

  def works?
    has_no_failure_comments? && has_working_comments?
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

  def dependency_packages
    self.dependencies.collect { |d|
      FedoraRpm.find_by_name 'rubygem-' + d.dependent
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

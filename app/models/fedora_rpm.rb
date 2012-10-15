require 'versionomy'
require 'xmlrpc/client'

class FedoraRpm < ActiveRecord::Base
  FEDORA_VERSIONS = {'rawhide'   => 'master',
                     'Fedora 18' => 'f18',
                     'Fedora 17' => 'f17',
                     'Fedora 16' => 'f16',
                     'Fedora 15' => 'f15'}

  belongs_to :ruby_gem
  has_many :rpm_versions, :dependent => :destroy
  has_many :rpm_comments, :dependent => :destroy, :order => 'created_at desc'
  has_many :bugs, :dependent => :destroy, :order => 'bz_id desc'
  has_many :builds, :dependent => :destroy, :order => 'build_id desc'
  has_many :working_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => true}
  has_many :failure_comments, :class_name => 'RpmComment', :conditions => {:works_for_me => false}
  has_many :dependencies, :as => :package, :dependent => :destroy, :order => 'created_at desc'
  scope :most_popular, :order => 'commits desc'
  scope :most_recent, :order => 'last_commit_date desc'

  def to_param
    name
  end

  def bugzilla_url
    "https://bugzilla.redhat.com/buglist.cgi?short_desc=.*#{name}.*&o1=equals&classification=Fedora&query_format=advanced&short_desc_type=regexp"
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
  rescue Exception => e
    return false
  end

  def json_dependencies(packages = [])
    children = []
    dependency_packages.each { |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependencies(packages)
      end
    }
    {"name" => name.gsub(/rubygem-/,''), "children" => children}
  end

  def json_dependents(packages = [])
    children = []
    dependent_packages.each { |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependents(packages)
      end
    }
    {"name" => name.gsub(/rubygem-/,''), "children" => children}
  end

  def retrieve_commits
    begin
      puts "Importing rpm #{name} commits"
      # parse commit log with nokogiri to determine how many commits there are
      log_uri = RpmImporter::BASE_URI + name + '.git/log/'
      git_log = URI.parse(log_uri).read
      doc = Nokogiri::HTML(git_log)
      self.commits = doc.xpath("//tr/td[@class='commitgraph']").select { |x| x.text == '* '}.size

      # parse last commit time
      commit_uri = RpmImporter::BASE_URI + name + '.git/commit/'
      git_commit = URI.parse(commit_uri).read
      doc = Nokogiri::HTML(git_commit)
      self.last_commit_date = DateTime.parse(doc.xpath("//table[@class='commit-info']/tr/td[@class='right']")[1].text)
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

        rpm_version = rpm_spec.scan(/\nVersion:\s*.*\n/).first.split.last
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
          self.homepage = rpm_spec.scan(/\nURL:\s*.*\n/).first.split.last

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

  def retrieve_bugs
    puts "Importing rpm #{name} bugs"
    self.bugs.clear

    bugzilla_search = URI.parse(bugzilla_url).read
    doc = Nokogiri::HTML(bugzilla_search)

    # get bugs and their titles
    bugs = doc.xpath("//td[@class='bz_short_desc_column']/a").collect { |bz| [bz.attr('href').gsub('show_bug.cgi?id=', ''), bz.text.strip] }
    bugs.each { |bug|
      arb = Bug.new :name => bug.last, :bz_id => bug.first
      arb.is_review = true if arb.name =~ /^Review Request.*#{name}\s.*$/
      self.bugs << arb
    }
  end

  def retrieve_builds
    puts "Importing rpm #{name} builds"
    self.builds.clear

    @@koji_search ||= XMLRPC::Client.new2(Build::KOJI_API_URL)
    builds = @@koji_search.call "search", name, "build", "regexp"
    builds.each { |build|
      bld = Build.new
      bld.name = build['name']
      bld.build_id = build['id']
      self.builds << bld
    }
  end

  def update_commits
    retrieve_commits
    self.updated_at = Time.now
    save!
  end

  def update_versions
    retrieve_versions
    self.updated_at = Time.now
    save!
  end

  def update_gem
    retrieve_gem
    self.updated_at = Time.now
    save!
  end

  def update_bugs
    retrieve_bugs
    self.updated_at = Time.now
    save!
  end

  def update_builds
    retrieve_builds
    self.updated_at = Time.now
    save!
  end

  def update_from_source
    update_commits
    update_versions
    update_gem
    update_bugs
    update_builds
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
    Dependency.find_all_by_dependent(self.name.gsub(/rubygem-/,'')).collect { |d|
      d.package if d.package.is_a?(FedoraRpm)
    }.compact
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

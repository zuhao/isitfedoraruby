require 'versionomy'
require 'xmlrpc/client'
require 'bugzilla'
require 'open-uri'

class FedoraRpm < ActiveRecord::Base
  FEDORA_VERSIONS = {'rawhide'   => 'master',
                     'Fedora 20' => 'f20',
                     'Fedora 19' => 'f19'}

  belongs_to :ruby_gem
  has_many :rpm_versions, :dependent => :destroy
  has_many :bugs, -> { order 'bz_id desc' }, :dependent => :destroy
  has_many :builds, -> { order 'build_id desc' }, :dependent => :destroy
  has_many :dependencies, -> { order  'created_at desc' }, :as => :package,
           :dependent => :destroy
  scope :most_recent, -> { order 'last_commit_date desc' }

  def to_param
    self.name
  end

  def shortname
    self.name.gsub(/rubygem-/, '')
  end

  def versions
    self.rpm_versions.collect { |rv| rv.to_s }.join(', ')
  end

  def version_for(fedora_version)
    rv = self.rpm_versions.find { |rv| rv.fedora_version == fedora_version }
    rv.rpm_version unless rv.nil?
  end

  def upto_date?
    rv = self.rpm_versions.find { |rv| rv.fedora_version == 'rawhide' }
    return false if rv.nil? || ruby_gem.nil? || ruby_gem.version.nil?
    begin
      Versionomy.parse(rv.rpm_version) >= Versionomy.parse(self.ruby_gem.version)
    rescue Versionomy::Errors::ParseError
      false
    end
  end

  def patched?
    self.rpm_versions.any? { |rv| rv.is_patched }
  end

  def json_dependencies(packages=[])
    children = []
    dependency_packages.each { |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependencies(packages)
      end
    }
    {name: shortname, children: children}
  end

  def json_dependents(packages=[])
    children = []
    dependent_packages.each do |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependents(packages)
      end
    end
    {name: shortname, children: children}
  end

  def base_uri
    'http://pkgs.fedoraproject.org/cgit/'
  end

  def retrieve_commits
    puts "Importing #{self.name} commits"

    # parse commit log with nokogiri to determine how many commits there are
    self.commits = 0
    offset = 0
    loop do
      log_uri = "#{base_uri}#{self.name}.git/log/?ofs=#{offset}"
      doc = Nokogiri::HTML(open(log_uri))
      ct = doc.xpath("//tr/td[@class='commitgraph']").count { |x| x.text == '* '}
      self.commits += ct
      offset += 50
      break if ct == 0
    end

    # parse last commit time
    commit_uri = "#{base_uri}#{self.name}.git/commit/"
    doc = Nokogiri::HTML(open(commit_uri))
    date = doc.xpath("//table[@class='commit-info']//td[@class='right']")[1].text
    self.last_commit_date = DateTime.parse(date)
  end

  def retrieve_versions
    puts "Importing #{name} versions and maintainer"
    self.rpm_versions.clear
    self.dependencies.clear
    FEDORA_VERSIONS.each do |version_title, version_git|
      spec_url = "#{base_uri}#{name}.git/plain/#{name}.spec?h=#{version_git}"
      puts "Reading spec from #{spec_url}"
      begin
        rpm_spec = URI.parse(spec_url).read
        is_patched = (rpm_spec.scan(/\nPatch0:\s*.*\n/).size != 0)

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
        rv.is_patched = is_patched
        self.rpm_versions << rv
        if version_title == 'rawhide'
          #Import the maintainer's e-mail
          fedora_user_list = rpm_spec.scan(/<.*[@].*>/)
          fedora_user_list.each do |user|
            if user != "<rel-eng@lists.fedoraproject.org>" #We don't want to add Fedora Release Engineering
              #Remove those "<>"
              user[0] = ""
              user.gsub!(">", "")
              self.fedora_user = user
              break
            end
          end
          puts "Maintainer: #{self.fedora_user}"

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
        puts "Could not retrieve version of #{name} for #{version_title}: #{e}"
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
    puts "Retrieving gem #{gem_name} data"
    self.ruby_gem = RubyGem.find_or_initialize_by_name(gem_name)
    self.ruby_gem.update_from_source
    self.ruby_gem.has_rpm = true
  end

  def retrieve_bugs
    puts "Importing rpm #{name} bugs"
    self.bugs.clear

    # get bugs and their titles and last_updated
    xmlrpc = Bugzilla::XMLRPC.new("bugzilla.redhat.com")
    bugs = Bugzilla::Bug.new(xmlrpc).search("summary" => name, "product" => "fedora")["bugs"]
    bugs.each { |bug|
      arb = Bug.new
      arb.name = bug["summary"]
      arb.bz_id = bug["id"]
      arb.last_updated = bug["last_change_time"].to_time
      arb.is_review = true if arb.name =~ /^Review Request.*#{name}\s.*$/
      arb.is_open = bug['is_open']
      self.bugs << arb
    }
  end

  def retrieve_builds
    puts "Importing rpm #{name} builds"
    self.builds.clear

    builds = Pkgwat.get_builds(name)
    builds.each { |build|
      bld = Build.new
      bld.name = build['nvr']
      bld.build_id = build['build_id']
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

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    if search == nil || search.blank?
      self
    else
      self.where('name LIKE ?', 'rubygem-' + search.strip)
    end
  end

  def dependency_packages
    self.dependencies.collect { |d|
      FedoraRpm.where(name: "rubygem-#{d.dependent}")
    }.compact
  end

  def dependent_packages
    Dependency.where(dependent: shortname).collect { |d|
      d.package if d.package.is_a?(FedoraRpm)
    }.compact
  end

  def self.build_rpms(spec_file)
    rpms = []
    buildroot = "#{Rails.root}/public/rpmbuild"
    output = `/usr/bin/rpmbuild --define="%_topdir #{buildroot}" -ba #{spec_file}`
    output.each_line { |l|
      rpms << $1 if l =~ /Wrote: (.*)/
    }
    rpms
  end

  def obfuscated_fedora_user
    return self.fedora_user.to_s.gsub("@", " AT ").gsub(".", " DOT ")
  end

private

  validates_uniqueness_of :name
  validates_presence_of :name

end

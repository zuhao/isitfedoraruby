# == Schema Information
#
# Table name: fedora_rpms
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  source_uri          :string(255)
#  last_commit_message :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  owner               :string(255)
#  last_committer      :string(255)
#  last_commit_date    :datetime
#  last_commit_sha     :string(255)
#  homepage            :string(255)
#  ruby_gem_id         :integer
#  commits             :integer
#  owner_email         :string(255)
#  summary             :text(255)
#  description         :text(255)
#

require 'versionomy'
require 'xmlrpc/client'
require 'bicho'
require 'open-uri'

# Used for packaged gems in Fedora
# - Retrieves dependencies
# - Retrieves koji builds
# - Retrieves bugs in bugzilla.redhat.com
# - Retrieves meta information about the gem
class FedoraRpm < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  validates :name, uniqueness: true
  validates :name, presence: true

  belongs_to :ruby_gem
  has_many :rpm_versions, dependent: :destroy
  has_many :bugs, -> { order 'bz_id desc' }, dependent: :destroy
  has_many :koji_builds, -> { order 'build_id desc' }, dependent: :destroy
  has_many :dependencies, -> { order 'created_at desc' }, as: :package,
                                                          dependent: :destroy
  scope :most_recent, -> { order 'last_commit_date desc' }

  def to_param
    name
  end

  def shortname
    name.gsub(/rubygem-/, '')
  end

  def self.fedora_versions

    # Read file which contains latest fedora version.
    # See lib/rawhide_version.rb
    # Get latest version with: "rake fedora:rawhide:create"
    file = File.open(Rails.root + 'public/version/rawhide', 'r')
    version = file.read.to_i

    { 'Rawhide'   => 'master',
      "Fedora #{version - 1}" => "f#{version - 1}",
      "Fedora #{version - 2}" => "f#{version - 2}"
    }
  end

  def up_to_date?
    rawhide_version = rpm_versions.find { |rv| rv.fedora_version == 'Rawhide' }
    return false if rawhide_version.nil? ||
                    rawhide_version.rpm_version.nil? ||
                    ruby_gem.nil? || ruby_gem.version.nil?
    begin
      Versionomy.parse(rawhide_version.rpm_version) >=
        Versionomy.parse(ruby_gem.version)
    rescue Versionomy::Errors::ParseError
      false
    end
  end

  def json_dependencies(packages = [])
    children = []
    dependency_packages.each do |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependencies(packages)
      end
    end
    { name: shortname, children: children }
  end

  def json_dependents(packages = [])
    children = []
    dependent_packages.each do |p|
      unless packages.include?(p)
        packages << p
        children << p.json_dependents(packages)
      end
    end
    { name: shortname, children: children }
  end

  def base_uri
    'http://pkgs.fedoraproject.org/cgit/'
  end

  # Get and store the commits metadata in database.
  def commits_metadata(name)
    pkg = Pkgwat.get_changelog(name)
    self.commits = pkg.count
    self.last_commit_message = pkg.first['text'].gsub(/^- /, '')
    self.last_committer = pkg.first['author']
    self.last_commit_date = pkg.first['date']
  end

  # Retrieve version for a specific release.
  # fedora_version can be one of three:
  # - "Rawhide"
  # - "Fedora 20"
  # - "Fedora 19"
  # Example:
  #   > name = 'rubygem-rails'
  #   > rpm = FedoraRpm.new
  #   > rpm.retrieve_version("Rawhide")
  #   > "4.1.4"
  def retrieve_version(fedora_version)
    rpm = Pkgwat.get_releases(name).select do |r|
      r['release'] == fedora_version
    end
    rpm.first['stable_version'].split('-').first
  end

  # Store the rpm versions of a given package of
  # all supported Fedora versions in rpm_versions table.
  def store_all_versions
    rpm_versions.clear
    self.class.fedora_versions.each do |version_title, version_git|
      rpm_version = retrieve_version(version_title)
      rv = RpmVersion.new
      rv.rpm_version = rpm_version
      rv.fedora_version = version_title
      rv.patched = patched?(version_git)
      rpm_versions << rv
    end
  end

  # Get a string of all packaged versions of a rubygem package.
  # It calls RpmVersion#to_s, see app/models/rpm_version.rb.
  # Example output in rails console:
  #   > name = 'rubygem-rails'
  #   > rpm = FedoraRpm.find_by(name: name);
  #   > rpm.versions
  #   > "4.1.4 (Rawhide/not patched), 4.0.0 (Fedora 20/not patched),
  #      3.2.13 (Fedora 19/not patched)"
  def versions
    rpm_versions.map { |rpm_version| rpm_version.to_s }.join(', ')
  end

  # Query the rpm_versions table for the package version of a given
  # Fedora version.
  # fedora_version can be one of three:
  # - "Rawhide"
  # - "Fedora 20"
  # - "Fedora 19"
  def version_for(fedora_version)
    version = rpm_versions.find { |rv| rv.fedora_version == fedora_version }
    version.rpm_version unless version.nil?
  end

  # Check if a version is valid: major.minor.patch
  def version_valid?(version)
    Versionomy.parse(version)
    true
  rescue Versionomy::Errors::ParseError
    false
  end

  # Check if any version is patched.
  # This then is passed to the view fedorarpms#index.
  def any_patched?
    rpm_versions.any? { |rpm_version| rpm_version.patched }
  end

  # Check if a version is patched by scrapping the spec file.
  # version_git can be one of the following:
  # - "master" for the rawhide version
  # - "fN" where N the Fedora version number, eg: 22,21,20,19,etc.
  # If no parameter is passed, it defaults to master.
  def patched?(version_git='master')
    spec_url = "#{base_uri}#{name}.git/plain/#{name}.spec?h=#{version_git}"
    rpm_spec = open(spec_url).read
    rpm_spec.scan(/\nPatch0:\s*.*\n/).size != 0
  end

  # Get the alias mail for the package.
  # It is forwarded to the real packagers' mail that is
  # registered with their FAS name.
  def get_owner_email
    "#{name}-owner@fedoraproject.org"
  end

  def obfuscated_email
    fedora_user.to_s.gsub('@', ' AT ').gsub('.', ' DOT ')
  end

  def fas_name
    Pkgwat.get_packages(name)[0]['devel_owner']
  end

  def retrieve_homepage(name)
    Pkgwat.get_packages(name)[0]['upstream_url']
  end

  def retrieve_dependencies
    dependencies.clear
    spec_url = "#{base_uri}#{name}.git/plain/#{name}.spec?h=master"
    rpm_spec = open(spec_url).read
    rpm_spec.split("\n").each do |line|
      mr = line.match(/^Requires:\s*rubygem\(([^\s]*)\)\s*(.*)$/)
      if mr.nil?
        mr = line.match(/^BuildRequires:\s*rubygem\(([^\s]*)\)\s*(.*)$/)
      end
      if mr
        d = Dependency.new
        d.dependent = mr.captures.first
        d.dependent_version = mr.captures.last
        dependencies << d
      end
    end
  end

  def retrieve_gem
    gem_name = shortname
    puts "Retrieving gem #{gem_name} data"
    self.ruby_gem = RubyGem.where(name: gem_name).first_or_create
    ruby_gem.update_from_source
    ruby_gem.has_rpm = true
  end

  def retrieve_bugs
    bugs.clear
    open_bugs = Pkgwat.get_bugs(name)

    open_bugs.reject { |b| b['release'].match(/EPEL/) }.each do |b|
      bug = Bug.new
      bug.name = b['description']
      bug.bz_id = b['id']
      bug.last_updated = b['last_modified']
      bug.is_review = true if b['name'] =~ /^Review Request.*#{name}\s.*$/
      bugs << bug
    end
  end

  def retrieve_builds
    koji_builds.clear

    version = RawhideVersion.version

    # Retrieve only latest 3 Fedora versions of builds
    koji_builds = Pkgwat.get_builds(name).select do |build|
      !!(build['nvr'] =~ /fc(#{version}|#{version - 1}|#{version - 2})/)
    end

    koji_builds.each do |build|
      bld = KojiBuild.new
      bld.name = build['nvr']
      bld.build_id = build['build_id']
      self.koji_builds << bld
    end
  end

  def update_commits
    commits_metadata(name)
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_dependencies
    retrieve_dependencies
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_versions
    store_all_versions
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_gem
    retrieve_gem
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_bugs
    retrieve_bugs
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_builds
    retrieve_builds
    self.updated_at = Time.now
    save!
  rescue => e
    puts "Updating #{name} failed due to #{e}"
  end

  def update_from_source
    update_commits
    update_specs
    update_gem
    update_bugs
    update_builds
  end

  def rpm_name
    name
  end

  def self.search(search)
    # search_cond = "%" + search.to_s + "%"
    # search_cond = search.to_s
    if search.nil? || search.blank?
      self
    else
      where('name LIKE ?', 'rubygem-' + search.strip)
    end
  end

  def dependency_packages
    dependencies.map do |d|
      FedoraRpm.where(name: "rubygem-#{d.dependent}").to_a
    end.compact.flatten
  end

  def dependent_packages
    Dependency.where(dependent: shortname).map do |d|
      d.package if d.package.is_a?(FedoraRpm)
    end.compact
  end

  def last_commit_date_in_words
    "#{time_ago_in_words(last_commit_date)} ago" unless last_commit_date.nil?
  end
end

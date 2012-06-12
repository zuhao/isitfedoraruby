require 'open-uri'
require 'git'

class RpmImporter

  GIT_BASE_URI = 'git://pkgs.fedoraproject.org/'
  FEDORAPKG_URI = 'http://pkgs.fedoraproject.org/gitweb/?a=project_index'
  RPM_GIT_DIR = 'rpmgit'

  def self.import 
    self.init
  	URI.parse(FEDORAPKG_URI).read.scan(/rubygem-.+\.git/).each do |index|
      rpm_git_uri = GIT_BASE_URI + index
      index.scan(/(.+)\.git/)
      @rpm_repos.add_remote($1, rpm_git_uri)
  	end
    @rpm_repos.remotes.each do|rpm_git_repo|
      rpm_git_repo.fetch
      Rpm.new_from_rpm_tuple({:name => rpm_git_repo.name,
                              :git_url => rpm_git_repo.url,
                              :last_commit_message => rpm_git_repo.branch.gcommit.message,
                              :author => rpm_git_repo.branch.gcommit.author.name,
                              :last_committer => rpm_git_repo.branch.gcommit.committer.name,
                              :ruby_gem_id => RubyGem.find_by_name($1).id})
  rescue Exception => ex 
  	puts ex.message
  end

  def self.init
    Dir.mkdir(RPM_GIT_DIR) if !File.directory?(RPM_GIT_DIR)
    FileUtils.remove_dir(RPM_GIT_DIR + '/.git') if File.directory?(RPM_GIT_DIR + '/.git')
    FileUtils.cd(RPM_GIT_DIR)
    @rpm_repos = Git.init
  end

end

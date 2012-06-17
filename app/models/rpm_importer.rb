require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/gitweb/?' #p=BackupPC.git;a=blob_plain;f=BackupPC.spec
  PKG_LIST_URI = BASE_URI + 'a=project_index'
  RPM_SPEC_URI = BASE_URI + 'a=blob_plain'

  def self.import
    # TODO: handle duplicates eg rubygem-foreigner.git vs rubygem-foreigner.git.sav
  	URI.parse(PKG_LIST_URI).read.scan(/rubygem-.+\.git\s/).each do |rpm|
      rpm_spec = URI.parse("#{RPM_SPEC_URI};p=#{rpm};f=#{rpm.gsub(/git$/,'spec')}")
      
    end

    # @rpm_repos.remotes.each do|rpm_git_repo|
    #   rpm_git_repo.fetch
    #   Rpm.new_from_rpm_tuple({:name => rpm_git_repo.name,
    #                           :git_url => rpm_git_repo.url,
    #                           :last_commit_message => rpm_git_repo.branch.gcommit.message,
    #                           :author => rpm_git_repo.branch.gcommit.author.name,
    #                           :last_committer => rpm_git_repo.branch.gcommit.committer.name,
    #                           :last_commit_sha => rpm_git_repo.branch.gcommit.sha,
    #                           :last_commit_date => rpm_git_repo.branch.gcommit.committer_date,
    #                           :ruby_gem_id => RubyGem.find_by_name(rpm_git_repo.name.gsub(/rubygem-/,'')).id})
    # end
  rescue Exception => ex 
  	puts ex.message
  end

end

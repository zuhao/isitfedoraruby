require 'open-uri'
require 'grit'

class RpmImporter

  GIT_BASE_URI = 'git://pkgs.fedoraproject.org/'
  FEDORAPKG_URI = 'http://pkgs.fedoraproject.org/gitweb/?a=project_index'

  def self.import 
  	URI.parse(FEDORAPKG_URI).read.scan(/rubygem-.+\.git/).each do |index|
      git_uri = GIT_BASE_URI + rpm_uri
      
      #Rpm.new_from_rpm_tuple(rpm_spec)
  	end
  rescue Exception => ex 
  	puts ex.message
  end

end

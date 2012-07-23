require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/gitweb/?'
  PKG_LIST_URI = BASE_URI + 'a=project_index'
  RPM_SPEC_URI = BASE_URI + 'a=blob_plain'
  GIT_LOG_URI  = BASE_URI + 'a=log'

  def self.import_all
  	URI.parse(PKG_LIST_URI).read.scan(/rubygem-.+\.git\s.+/).each do |rpm|
      FedoraRpm.new_from_rpm_tuple(rpm)
    end
  rescue Exception => ex
  	puts ex.message
  end

end

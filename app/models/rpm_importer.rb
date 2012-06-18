require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/gitweb/?'
  PKG_LIST_URI = BASE_URI + 'a=project_index'
  RPM_SPEC_URI = BASE_URI + 'a=blob_plain'

  def self.import
  	URI.parse(PKG_LIST_URI).read.scan(/rubygem-.+\.git/).each do |rpm|
      puts "importing #{rpm}"
      FedoraRpm.new_from_rpm_tuple(rpm) 
      puts "#{rpm} imported"
    end
  rescue Exception => ex 
  	puts ex.message
  end

end

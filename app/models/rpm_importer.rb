require 'open-uri'

class RpmImporter

  FEDORAPKG_URI = 'https://admin.fedoraproject.org'
  QUERY = '/pkgdb/acls/list/?searchwords=rubygem-*&packages_tgp_limit=-1'

  def self.import 
  	URI.parse(FEDORAPKG_URI + QUERY).read.scan(/\/pkgdb\/acls\/name\/rubygem-.+\?/).each do |rpm_uri|
      rpm_uri = FEDORAPKG_URI + rpm_uri.chomp('?')
      puts rpm_uri
  	end
  rescue Exception => ex 
  	puts ex.message
  end

end

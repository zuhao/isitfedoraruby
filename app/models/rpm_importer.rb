require 'open-uri'

class RpmImporter

  RPMS_LIST_FILE = 'app/models/rpmslist.txt'
  BASE_URI = 'http://pkgs.fedoraproject.org/gitweb/?'
  PKG_LIST_URI = BASE_URI + 'a=project_index'
  RPM_SPEC_URI = BASE_URI + 'a=blob_plain'
  GIT_LOG_URI  = BASE_URI + 'a=log'

  def self.import_all
  	File.open(RPMS_LIST_FILE, 'r').each do |f|
      rpm_name = f.strip
      puts "Importing #{rpm_name} ..."
      FedoraRpm.new_from_name(rpm_name)
    end
  rescue Exception => ex
  	puts ex.message
  end

  def self.import_batch(batch_number = 2, delay = 1)
    self.import_rpms_list unless File.exists?(RPMS_LIST_FILE)
    counter = 0
    File.open(RPMS_LIST_FILE, 'r').each do |f|
      counter = counter.next
      if counter % batch_number == 0
        puts "Delaying for #{delay} seconds ..."
        sleep delay
      end
      rpm_name = f.strip
      puts "Importing #{rpm_name} ..."
      FedoraRpm.new_from_name(rpm_name)
    end
  rescue Exception => ex
    puts ex.message
  end

  def self.import_rpms_list
    File.open(RPMS_LIST_FILE, 'w+') do |f|
      URI.parse(PKG_LIST_URI).read.scan(/rubygem-.+\.git\s.+/).each do |rpm|
        rpm_name = rpm.split.first.gsub(/\.git/,'')
        f.write(rpm_name + "\n")
      end
    end
    puts "Rpms list imported."
  rescue Exception => ex
    puts "Import failed due to eror #{ex}."
  end

end

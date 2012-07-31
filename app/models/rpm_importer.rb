require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/gitweb/?'
  PKG_LIST_URI = BASE_URI + 'a=project_index'
  RPM_SPEC_URI = BASE_URI + 'a=blob_plain'
  GIT_LOG_URI  = BASE_URI + 'a=log'

  def self.import_all
    total = 0
    rpms = FedoraRpm.find(:all)
    rpms.each { |f|
      puts "Updating #{f.name} (#{total += 1}/#{rpms.size})..."
      f.update_from_source
    }
  rescue Exception => ex
	puts ex.message
  end

  def self.import_batch(batch_number = 2, delay = 1)
    counter = 0 ; total = 0
    rpms = FedoraRpm.find(:all)
    rpms.each { |f|
      if counter == batch_number
        puts "Delaying for #{delay} seconds ..."
        sleep delay
        counter = 0
      end
      counter += 1
      puts "Updating #{f.name} (#{total += 1}/#{rpms.size})..."
      f.update_from_source
    }
  rescue Exception => ex
    puts ex.message
  end

  def self.import_rpms_list
    puts "Importing rpm list"
    URI.parse(PKG_LIST_URI).read.scan(/rubygem-.+\.git\s.+/).each do |rpm|
      rpm_name = rpm.split.first.gsub(/\.git/,'')
      puts "Importing rpm #{rpm_name}"
      if FedoraRpm.find_by_name(rpm_name).nil?
        r = FedoraRpm.new
        r.name = rpm_name
        r.source_uri = "git://pkgs.fedoraproject.org/#{rpm_name}.git"
        r.save!
      else
        puts "rpm #{rpm_name} already imported"
      end
    end
    puts "Rpms list imported."
  rescue Exception => ex
    puts "Import failed due to eror #{ex}."
  end

  def self.update_rpms(days_since_last_update)
    seconds_since_last_update = 60 * 60 * 24 * days_since_last_update
    rpms = FedoraRpm.find :all, :conditions => 
      ["DATETIME(updated_at) < '#{(Time.now - seconds_since_last_update).utc}'"]
    rpms.each { |rpm|
      puts "Updating rpm #{rpm.name}"
      rpm.update_from_source
    }
  end

end

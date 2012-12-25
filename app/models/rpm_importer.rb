require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/cgit/'

  def self.import_oldest(number)
    total = 0
    rpms = FedoraRpm.order("updated_at ASC").limit(number)
    rpms.each { |f|
      puts "Updating #{f.name} (#{total += 1}/#{rpms.size})..."
      f.update_from_source
    }
    rescue Exception => ex
      puts ex.message    
  end
  
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

  def self.import_batch(batch_number = 50, delay = 10)
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
    rpms = Pkgwat.get_packages("rubygem")
    rpms.each { |rpm|
      rpm_name = rpm["name"]
      puts "Importing rpm #{rpm_name}"
      if FedoraRpm.find_by_name(rpm_name).nil?
	r = FedoraRpm.new
	r.name = rpm_name
	r.source_uri = "git://pkgs.fedoraproject.org/#{rpm}"
	r.save!
      else
	puts "rpm #{rpm_name} already imported"
      end
    }
    puts "Rpms list imported."
    rescue Exception => ex
      puts "Import failed due to eror #{ex}."
  end

  def self.update_rpms(days_since_last_update, mode)
    seconds_since_last_update = 60 * 60 * 24 * days_since_last_update
    rpms = FedoraRpm.find :all, :conditions => ["DATETIME(updated_at) < '#{(Time.now - seconds_since_last_update).utc}'"]
    rpms.each { |rpm|
      puts "Updating rpm #{rpm.name} #{mode}"
      case mode
      when 'all' then
        rpm.update_from_source
      when 'commits' then
        rpm.update_commits
      when 'versions' then
        rpm.update_versions
      when 'bugs' then
        rpm.update_bugs
      when 'builds' then
        rpm.update_builds
      end
    }
  end

end
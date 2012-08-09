require 'open-uri'

class RpmImporter

  BASE_URI = 'http://pkgs.fedoraproject.org/cgit/'
  PKG_LIST_URI = BASE_URI + '?q=rubygem-'

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
    offset = 0
    loop do
      list_page = URI.parse(PKG_LIST_URI + '&ofs=' + offset.to_s).read
      doc = Nokogiri::HTML(list_page)
      rpms = doc.xpath("//tr/td[@class='toplevel-repo']/a/@title")
      break if rpms.empty?
      rpms.each { |rpm|
        rpm_name = rpm.value.gsub(/\.git.*/,'')
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
      offset += 50
    end
    puts "Rpms list imported."
  rescue Exception => ex
    puts "Import failed due to eror #{ex}."
  end

  def self.update_rpms(days_since_last_update)
    seconds_since_last_update = 60 * 60 * 24 * days_since_last_update
    rpms = FedoraRpm.find :all, :conditions => ["DATETIME(updated_at) < '#{(Time.now - seconds_since_last_update).utc}'"]
    rpms.each { |rpm|
      puts "Updating rpm #{rpm.name}"
      rpm.update_from_source
    }
  end

end

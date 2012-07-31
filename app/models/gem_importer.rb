require 'rubygems'

class GemImporter

  RUBYGEMS_URI = 'http://rubygems.org/'
  API_ENDPOINT = 'api/v1/gems/'
  DOWNLOADS_ENDPOINT = 'api/v1/downloads/all.json' # top 50 downloads of all time

  def self.import_all
    total = 0
    gems = RubyGem.find(:all)
    gems.each { |g|
      puts "Updating #{g.name} (#{total += 1}/#{gems.size}) ..."
      g.update_from_source
    }
  rescue Exception => ex
    puts ex.message
  end

  def self.import_batch(batch_number = 50, delay = 10)
    counter = 0 ; total = 0
    gems = RubyGem.find(:all)
    gems.each { |g|
      if counter == batch_number
        puts "Delaying for #{delay} seconds ..."
        sleep delay
        counter = 0
      end
      counter += 1
      puts "Updating #{g.name} (#{total += 1}/#{gems.size})..."
      g.update_from_source
    }
  rescue Exception => ex
    puts ex.message
  end

  def self.import_gems_list(selection = :all)
    puts "Importing gem list"

    gems = []
    if selection == :all
      gems = Gem::SpecFetcher.fetcher.list[URI.parse(RUBYGEMS_URI)].collect { |g| g.first }
    elsif selection == :top
      downloads = JSON.parse(Curl::Easy.http_get(RUBYGEMS_URI + DOWNLOADS_ENDPOINT).body_str)
      downloads['gems'].each { |g|
        name = g[0]['full_name'].split('-')
        name.delete_at(-1)
        name = name.join('-')
        gems << name
      }
    end

    # TODO: is there a 'lighter' way to fetch the list of all gem names?
    gems.each do |gem_name|
      puts "Importing gem #{gem_name}"
      if RubyGem.find_by_name(gem_name).nil?
        g = RubyGem.new
        g.name = gem_name
        g.save!
      else
        puts "gem #{gem_name} already imported"
      end
    end
    puts "Gems list imported."
  rescue Exception => ex
    puts "Import failed due to error #{ex}."
  end

  def self.update_gems(days_since_last_update)
    seconds_since_last_update = 60 * 60 * 24 * days_since_last_update
    gems = RubyGem.find :all, :conditions => 
      ["DATETIME(updated_at) < '#{(Time.now - seconds_since_last_update).utc}'"]
    gems.each { |gem|
      puts "Updating gem #{gem.name}"
      gem.update_from_source
    }
  end

end

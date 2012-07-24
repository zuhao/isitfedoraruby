require 'rubygems'

class GemImporter

  GEMS_LIST_FILE = 'app/models/gemslist.txt'
  RUBYGEMS_URI = 'http://rubygems.org/'
  API_ENDPOINT = 'api/v1/gems/'
  DOWNLOADS_ENDPOINT = 'api/v1/downloads/all.json' # top 50 downloads of all time

  def self.import_all
    File.open(GEMS_LIST_FILE, 'r').each do |f|
      gem_name = f.strip
      puts "Importing #{gem_name} ..."
      RubyGem.new_from_name(gem_name)
    end
  rescue Exception => ex
    puts ex.message
  end

  def self.import_batch(batch_number = 50, delay = 10)
    self.import_gems_list unless File.exists?(GEMS_LIST_FILE)
    counter = 0
    File.open(GEMS_LIST_FILE, 'r').each do |f|
      counter = counter.next
      if counter % batch_number == 0
        puts "Delaying for #{delay} seconds ..."
        sleep delay
      end
      gem_name = f.strip
      puts "Importing #{gem_name} ..."
      RubyGem.new_from_name(gem_name)
    end
  rescue Exception => ex
    puts ex.message
  end

  def self.import_gems_list
    # TODO: is there a 'lighter' way to fetch the list of all gem names?
    File.open(GEMS_LIST_FILE, 'w+') do |f|
      Gem::SpecFetcher.fetcher.list[URI.parse(RUBYGEMS_URI)].each do |gem|
        gem_name = gem.first
        f.write(gem_name + "\n")
      end
    end
    puts "Gems list imported."
  rescue Exception => ex
    puts "Import failed due to error #{ex}."
  end
end

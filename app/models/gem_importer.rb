require 'rubygems'
require "rubygems/spec_fetcher"

class GemImporter

  API_ENDPOINT = 'api/v1/gems/'
  DOWNLOADS_ENDPOINT = 'api/v1/downloads/all.json' # top 50 downloads of all time

  RUBYGEMS_URI = 'http://rubygems.org/'

  def self.import
    downloads = JSON.parse(Curl::Easy.http_get(RUBYGEMS_URI + DOWNLOADS_ENDPOINT).body_str)
    downloads['gems'].each { |g|
      name = g[0]['full_name'].split('-')
      name.delete_at(-1)
      name = name.join("-")
      RubyGem.new_from_name(name)
    }
  rescue Exception => ex
      puts ex.message
  end

end

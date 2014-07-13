require 'open-uri'
class RawhideVersion
  # Retrieve rawhide version
  def self.version
    url = 'https://admin.fedoraproject.org/pkgdb/api/collections?pattern=master'
    uri = open(url).read
    result = JSON.parse(uri)
    result['collections'][0]['dist_tag'].gsub(/.fc/, '').to_i
  end

  def self.create_file
    version = self.version.to_s
    filename = 'rawhide'
    directory = Rails.root + 'public/version/'
    path = File.join(directory, filename)
    File.open(path, 'w') { |f| f.write(version) }
  end
end

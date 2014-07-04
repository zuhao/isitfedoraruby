require 'open-uri'
class RawhideVersion
  # Retrieve rawhide version
  def self.version
    url = 'https://admin.fedoraproject.org/pkgdb/collection/master/'
    page = Nokogiri::HTML(open(url))
    page.text.match(/\d{2}/)[0].to_i
  end

  def self.create_file
    version = self.version.to_s
    filename = 'rawhide'
    directory = Rails.root + 'public/version/'
    path = File.join(directory, filename)
    File.open(path, 'w') { |f| f.write(version) }
  end
end

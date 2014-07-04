namespace :fedora do
  namespace :rawhide do

    desc 'FEDORA | Get Fedora rawhide(development) version'
    task version: :environment do
      puts 'Fetching Fedora rawhide version...'
      puts "Fedora rawhide version is #{RawhideVersion.version}."
    end

    desc 'FEDORA | Create file containing Fedora rawhide(development) version'
    task create: :environment do
      # Make sure 'public/rawhide/' exists
      path = Rails.root + 'public/version/'
      FileUtils.mkdir_p path unless path.exist?
      puts 'Creating file...'
      RawhideVersion.create_file
      puts "Created #{path}rawhide."
    end # file
  end # rawhide
end # fedora

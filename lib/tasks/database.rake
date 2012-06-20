namespace :database do
  desc 'import gems from rubygems.org'
  task :import_gems => :environment do
    GemImporter.import
  end

  desc 'import rpms from fedora'
  task :import_rpms => :environment do 
    RpmImporter.import
  end
  
end

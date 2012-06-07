namespace :database do
  desc 'import gems from rubygems.org'
  task :import_gems => :environment do
    GemImporter.import
  end
end

require 'fileutils'
namespace :fedoraruby do
  desc 'create necessary application directories'
  task :dirs do
    FileUtils.mkdir_p 'public/rpmbuild/SOURCES'
    FileUtils.mkdir_p 'public/rpmbuild/SPECS'
  end
end

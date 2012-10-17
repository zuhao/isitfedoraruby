class BuildsController < ApplicationController
  def import
    if params[:gem] && params[:version]
      @version = params[:version]
      @gem = RubyGem.find_by_name(params[:gem])

      # recursively import all dependencies
      @gem.retrieve_metadata
      @packages = [{:gem => @gem, :version => @version}]
      @packages.each { |p|
        p[:gem].dependencies.each { |d|
          unless d.dependent_package.nil? ||
                 @packages.collect { |pkg| pkg[:gem] }.include?(d.dependent_package)
            @packages << {:gem => d.dependent_package,
                          :version => d.dependent_version.split.last}
          end
        }
      }

      # build rpms from the deps 
      @packages.each { |pkg|
        # download the gem
        pkg[:gem].download_version(pkg[:version])

        # convert to rpm
        spec_file = pkg[:gem].version2rpm(pkg[:version])

        # if we can't retrieve specific version, d/l pkg
        if File.zero?(spec_file)
          pkg[:gem].download
          spec_file = pkg[:gem].gem2rpm
        end

        pkg[:spec_path] = spec_file.gsub(/#{Rails.root}\/public/, "")
        pkg[:spec_name] = pkg[:spec_path].split("/").last
        #pkg[:rpms] = FedoraRpm.build_rpms spec_file
      }

      # TODO run this in a lock
      #`createrepo #{Rails.root}/public/rpmbuild/RPMS`

    elsif params[:gem]
      @gem = RubyGem.load_or_create params[:gem]
      if @gem.nil?
        @errors = ["#{params[:gem]} cannot be found on rubygems"]
        return
      end

      @versions = @gem.retrieve_versions
puts "!!! #{@versions}"
      @versions = @versions.collect { |v| v['number'] }
    end
  end

  def build
    gem = RubyGem.find_by_name(params[:gem])
    version = params[:version]
  end
end

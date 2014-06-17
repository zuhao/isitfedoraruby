class BuildsController < ApplicationController
  def import
    if params[:gem] && params[:version]
      @version = params[:version]
      @gem = RubyGem.find_by_name(params[:gem])

      # recursively import all dependencies
      @gem.retrieve_metadata
      @packages = [{ gem: @gem, version: @version }]
      @packages.each do |p|
        p[:gem].dependencies.each do |dep|
          unless dep.dependent_package.nil? ||
                 @packages.map { |pkg| pkg[:gem] }.include?(d.dependent_package)
            @packages << { gem: d.dependent_package,
                           version: d.dependent_version.split.last }
          end
        end
      end

      # build rpms from the deps
      @packages.each do |pkg|
        # download the gem
        pkg[:gem].download_version(pkg[:version])

        # convert to rpm
        spec_file = pkg[:gem].version2rpm(pkg[:version])

        # if we can't retrieve specific version, d/l pkg
        if File.zero?(spec_file)
          pkg[:gem].download
          spec_file = pkg[:gem].gem2rpm
        end

        pkg[:spec_path] = spec_file.gsub(/#{Rails.root}\/public/, '')
        pkg[:spec_name] = pkg[:spec_path].split('/').last
        # pkg[:rpms] = FedoraRpm.build_rpms spec_file
      end

      # TODO: Run this in a lock
      # `createrepo #{Rails.root}/public/rpmbuild/RPMS`

    elsif params[:gem]
      @gem = RubyGem.load_or_create params[:gem]
      if @gem.nil?
        @errors = ["#{params[:gem]} cannot be found on rubygems"]
        return
      end

      @versions = @gem.gem_versions
    end
  end

  def build
    RubyGem.find_by_name(params[:gem])
    params[:version]
  end
end

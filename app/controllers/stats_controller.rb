class StatsController < ApplicationController
  def index
    @rpms = FedoraRpm.order('commits desc').limit(10)
    @gems = RubyGem.order('downloads desc').limit(10)
  end

  def user_rpms_data
    @name = params[:stat_id]
    @rpms = FedoraRpm.where("fedora_user LIKE ?", @name + "@%")
    respond_to do |format|
      format.json { render json }
    end
  end

  def user_rpms
    @name = params[:stat_id]
    @rpms = FedoraRpm.where("fedora_user LIKE ?", @name + "@%")
    @rpms_json = @rpms.to_json
    respond_to do |format|
      format.html
    end
  end

  def timeline (result = [])
	@stat_id = params[:stat_id]
	@rpm = FedoraRpm.find_by_name(@stat_id)
	@rpm.ruby_gem.historical_gems.each { |h|
	result << { :content => h.version, :start => h.build_date }
	}
	@rpm.bugs.each { |b|
	result << { :content => b.name + "<br><a href='"+b.url+"'>View on BugZilla</a>", :start => b.bz_id }
	}
	@res = result.to_json
	respond_to do |format|
      	format.html
    	end
  end

  def gemfile_tool
    if params[:gemfile]
      @gemfile = params[:gemfile]
      unless @gemfile.is_a?(String)
        @gemfile = @gemfile.read
      end

      @gemfile.gsub!(/\r*/, '')

      is_lock = !@gemfile.scan(/\nGEM\n/).empty?
      is_lock = !@gemfile.scan(/\nPLATFORMS\n/).empty?    unless is_lock
      is_lock = !@gemfile.scan(/\nDEPENDENCIES\n/).empty? unless is_lock

      lines = @gemfile.split "\n"

      dependencies = []
      @result = []

      # FIXME very hacky way to do this,
      # most likely we can leverage the bundler api instead
      if !is_lock
        lines.each { |line|
          if line =~ /^gem\s+'([^']*)'$/
            # gem name only
           dependencies << {:name => $1, :version => nil}

          elsif line =~ /^gem\s+'([^']*)',\s*'([^']*)'.*$/
            # gem with possible version
            name = $1
            version = nil
            begin
              version = Versionomy.parse($2.split.last)
            rescue Versionomy::Errors::ParseError
            end
            dependencies << {:name => name, :version => version}

            #else # ignore
          end
        }
      else
        lines.each { |line|
          if line =~ /^\s*([^\s]*)\s*\(([^\)]*)\)$/
            # gem name / version
            name, version = $1, $2
            begin
              version = Versionomy.parse(version.split.last)
            rescue Versionomy::Errors::ParseError
            end
            dependencies << {:name => name, :version => version}
          end
        }
      end

      dependencies.each { |dep|
        unless @result.find { |res| res[:name] == dep[:name] }
          dep_fully_satisfied = true
          rpm = FedoraRpm.find_by_name("rubygem-" + dep[:name])
          if !rpm
            dep_fully_satisfied = false
            @result << {:name => dep[:name], :success => false, :message => "#{dep[:name]} not found in Fedora"}

          elsif !dep[:version].nil?
            rpm.rpm_versions.each { |rv|
              unless rv.rpm_version.nil?
                if Versionomy.parse(rv.rpm_version) < dep[:version]
                  dep_fully_satisfied = false
                  @result << {:name => dep[:name], :success => false, :message => "#{dep[:name]} (#{dep[:version]}) is too old in #{rv.fedora_version} (which has #{rv.rpm_version})"}

                else # TODO comment: (?)
                  @result << {:name => dep[:name], :success => true, :message => "#{dep[:name]} (#{dep[:version]}) is sufficient in #{rv.fedora_version}!"}
                end
              end
            }
          end

          if dep_fully_satisfied
            @result << {:name => dep[:name], :success => true, :message => "#{dep[:name]} is in Fedora!"}
          end
        end
      }
    end
  end
end

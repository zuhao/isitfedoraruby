class StatsController < ApplicationController
  def index
    @rpms = FedoraRpm.order('commits desc').limit(10)
    @gems = RubyGem.order('downloads desc').limit(10)
  end

  def user_rpms_data
    @name = params[:stat_id]
    @rpms = FedoraRpm.where('fedora_user LIKE ?', @name + '@%')
    respond_to do |format|
      format.json { render json: @rpms.to_json }
    end
  end

  def user_rpms
    @name = params[:stat_id]
    @rpms = FedoraRpm.where('fedora_user LIKE ?', @name + '@%')
    @rpms_json = @rpms.to_json
    respond_to do |format|
      format.html
    end
  end

  def timeline
    @stat_id = params[:stat_id]
    respond_to do |format|
      format.html
    end
  end

  def tljson(result = [])
    @stat_id = params[:stat_id]
    @rpm = FedoraRpm.find_by_name(@stat_id)
    @rpm.ruby_gem.historical_gems.each do |hist_gem|
      result << { content: hist_gem.version, start: hist_gem.build_date }
    end
    @rpm.bugs.each do |bug|
      result << { content: bug.name, start: bug.bz_id }
    end
    @res = result.to_json
    respond_to do |format|
      format.json { render json: @res }
    end
  end

  # FIXME: Use polisher to compare the Gemfile against Fedora
  def gemfile_tool
    if params[:gemfile]

      @gemfile = params[:gemfile]
      @gemfile = @gemfile.read unless @gemfile.is_a?(String)

      @gemfile.gsub!(/\r*/, '')

      is_lock = !@gemfile.scan(/\nGEM\n/).empty?
      is_lock = !@gemfile.scan(/\nPLATFORMS\n/).empty?    unless is_lock
      is_lock = !@gemfile.scan(/\nDEPENDENCIES\n/).empty? unless is_lock

      lines = @gemfile.split "\n"

      dependencies = []
      @result = []

      if !is_lock
        lines.each do |line|
          if line =~ /^gem\s+'([^']*)'$/
            # gem name only
            dependencies << { name: Regexp.last_match[1], version: nil }

          elsif line =~ /^gem\s+'([^']*)',\s*'([^']*)'.*$/
            # gem with possible version
            name = Regexp.last_match[1]
            version = nil
            begin
              version = Versionomy.parse(Regexp.last_match[2].split.last)
            rescue Versionomy::Errors::ParseError
            end
            dependencies << { name: name, version: version }

            # else # ignore
          end
        end
      else
        lines.each do |line|
          if line =~ /^\s*([^\s]*)\s*\(([^\)]*)\)$/
            # gem name / version
            name, version = Regexp.last_match[1], Regexp.last_match[2]
            begin
              version = Versionomy.parse(version.split.last)
            rescue Versionomy::Errors::ParseError
            end
            dependencies << { name: name, version: version }
          end
        end
      end

      dependencies.each do |dep|
        unless @result.find { |res| res[:name] == dep[:name] }
          dep_fully_satisfied = true
          rpm = FedoraRpm.find_by_name('rubygem-' + dep[:name])
          if !rpm
            dep_fully_satisfied = false
            @result << { name: dep[:name], success: false, message: _('%{dep_name} not found in Fedora') % { dep_name: dep[:name] } }

          elsif !dep[:version].nil?
            rpm.rpm_versions.each do |rv|
              unless rv.rpm_version.nil?
                if Versionomy.parse(rv.rpm_version) < dep[:version]
                  dep_fully_satisfied = false
                  @result << { name: dep[:name], success: false, message: _('%{dep_name} (%{dep_version}) is too old in %{rv_fedora_version} (which has %{rv_rpm_version})') % { dep_name: dep[:name], dep_version: dep[:version], rv_fedora_version: rv.fedora_version, rv_rpm_version: rv.rpm_version } }

                else
                  @result << { name: dep[:name], success: true, message: _('%{dep_name} (%{dep_version}) is sufficient in %{rv_fedora_version}') % { dep_name: dep[:name], dep_version: dep[:version], rv_fedora_version: rv.fedora_version } }
                end
              end
            end
          end

          if dep_fully_satisfied
            @result << { name: dep[:name], success: true, message: _('%{dep_name} is in Fedora!') % { dep_name: dep[:name] } }
          end
        end
      end
    end
  end
end

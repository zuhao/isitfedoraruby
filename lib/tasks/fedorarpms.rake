namespace :fedorarpms do

  desc 'Import a list of names of all rpms from apps.fedoraproject.org'
  task :import_names => :environment do

    # Patch Pkgwat.parse_results because rubygem-fast_xs description
    module ::Pkgwat
      def self.parse_results(results)
        results.gsub!(/\\""\\"/, '\"&quot;\"')
        results = JSON.parse(results)
        results["rows"]
      end
    end

    rpms = Pkgwat.get_packages('rubygem-')
    rpms.each do |rpm|
      name = rpm['name']
      if FedoraRpm.find_by_name(name).nil?
        r = FedoraRpm.new
        r.name = name
        r.summary = rpm['summary']
        r.description = rpm['description']
        r.author = rpm['devel_owner']
        r.source_uri = "git://pkgs.fedoraproject.org/#{name}"
        gem_name = name.gsub(/rubygem-/, '')
        r.ruby_gem = RubyGem.find_or_initialize_by(name: gem_name)
        r.save!
      end
    end
    puts "Rpm list of #{rpms.size} imported."
  end

  desc 'Import rpms'
  task :import_rpms, [:number, :delay] => [:import_names, :environment] do
    args.with_defaults(number: 100, delay: 5)
    total = 0
    counter = 0
    number_in_batch = args[:number].to_i
    delay = args[:delay].to_i
    rpms = FedoraRpm.all
    rpms.each do |r|
      if counter == batch_number
        puts "Delaying for #{delay} seconds ..."
        sleep delay
        counter = 0
      end
      counter += 1
      puts "Updating #{r.name} (#{total += 1}/#{rpms.size}) ..."
      r.update_from_source
      puts "#{r.name} updated."
    end
  end

end

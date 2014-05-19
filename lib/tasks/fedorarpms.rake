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
    rpms.select{|r| r['name'].start_with?('rubygem-')}.each do |rpm|
      name = rpm['name']
      FedoraRpm.where(name: name).first_or_create! do |r|
        r.name = name
        r.summary = rpm['summary']
        r.description = rpm['description']
        r.author = rpm['devel_owner']
        r.source_uri = "git://pkgs.fedoraproject.org/#{name}"
        gem_name = name.gsub(/rubygem-/, '')
        r.ruby_gem = RubyGem.where(name: gem_name).first_or_create!
      end
    end
    puts "Rpm list of #{rpms.size} imported."
  end

  desc 'Import rpms'
  task :import_rpms, [:number, :delay] => :environment do |t, args|
    args.with_defaults(number: 100, delay: 5)
    total = 0
    counter = 0
    number_in_batch = args[:number].to_i
    delay = args[:delay].to_i
    rpms = FedoraRpm.all
    rpms.each do |r|
      if counter == number_in_batch
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

  desc 'Update rpms'
  task :update_rpms, [:age] => :environment do |t, args|
    args.with_defaults(age: 7)
    age = args[:age].to_i
    last_update = (Time.now - 60 * 60 * 24 * age).utc
    FedoraRpm.all.where('DATETIME(updated_at) < ?', last_update).each do |r|
      puts "Updating #{r.name}"
      r.update_from_source
      puts "#{r.name} updated."
    end
  end

  desc 'Update oldest n rpms'
  task :update_oldest_rpms, [:number] => :environment do |t, args|
    args.with_defaults(number: 10)
    number = args[:number].to_i
    total = 0
    rpms = FedoraRpm.order("updated_at ASC").limit(number)
    rpms.each do |r|
      puts "Updating #{r.name} (#{total += 1}/#{rpms.size})..."
      r.update_from_source
      puts "#{r.name} updated."
    end
  end

end

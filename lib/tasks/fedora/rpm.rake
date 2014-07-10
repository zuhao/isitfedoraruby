namespace :fedora do
  namespace :rpm do
    namespace :import do

      desc 'FEDORA | Import bugs of a given rubygem package'
      task :bugs, [:rpm_name] => :environment do |t, args|
        rpm = args.rpm_name
        puts "Importing #{rpm} bugs..."
        FedoraRpm.find_by(name: rpm).update_bugs
      end

      desc 'FEDORA | Import koji builds of a given rubygem package'
      task :koji_builds, [:rpm_name] => :environment do |t, args|
        rpm = args.rpm_name
        puts "Importing #{rpm} koji builds..."
        FedoraRpm.find_by(name: rpm).update_builds
      end

      desc 'FEDORA | Import commits of a given rubygem package'
      task :commits, [:rpm_name] => :environment do |t, args|
        rpm = args.rpm_name
        puts "Importing #{rpm} commits..."
        FedoraRpm.find_by(name: rpm).update_commits
      end

      desc 'FEDORA | Import depedencies of a given rubygem package'
      task :deps, [:rpm_name] => :environment do |t, args|
        rpm = args.rpm_name
        puts "Importing #{rpm} dependencies..."
        FedoraRpm.find_by(name: rpm).update_specs
      end

      desc 'FEDORA | Import respective gem of a given rubygem package'
      task :gem, [:rpm_name] => :environment do |t, args|
        rpm = args.rpm_name
        puts "Importing #{rpm} gem..."
        FedoraRpm.find_by(name: rpm).update_gem
      end

      desc 'FEDORA | Import a list of names of all rubygems from apps.fedoraproject.org'
      task :names => :environment do

        # Patch Pkgwat.parse_results because rubygem-fast_xs description
        module ::Pkgwat
          def self.parse_results(results)
            results.gsub!(/\\""\\"/, '\"&quot;\"')
            results = JSON.parse(results)
            results["rows"]
          end
        end

        rpms = Pkgwat.get_packages('rubygem-').select do |rpm|
          rpm['name'].start_with?('rubygem-')
        end

        puts "Importing rpm list of #{rpms.size} rubygem packages ..."

        rpms.each do |rpm|
          name = rpm['name']
          FedoraRpm.where(name: name).first_or_create! do |r|
            r.name = name
            r.summary = rpm['summary']
            r.description = rpm['description']
            r.owner = rpm['devel_owner']
            r.owner_email = "#{name}-owner@fedoraproject.org"
            r.source_uri = "http://pkgs.fedoraproject.org/cgit/#{name}.git"
            gem_name = name.gsub(/rubygem-/, '')
            # TODO: transfer this to rubygem task
            r.ruby_gem = RubyGem.where(name: gem_name).first_or_create!
          end
        end
        puts "Rpm list of #{rpms.size} rubygem packages imported."
      end

      desc 'FEDORA | Import ALL rpm metadata (time consuming)'
      task :all, [:number, :delay] => :environment do |t, args|
        puts "This will take some time and will rewrite the database."
        ask_to_continue
        args.with_defaults(number: 100, delay: 5)
        total = 0
        counter = 0
        number_in_batch = args[:number].to_i
        delay = args[:delay].to_i
        Rake::Task["fedora:import:rpm:names"].invoke
        rpms = FedoraRpm.all
        rpms.each do |r|
          if counter == number_in_batch
            puts "Delaying for #{delay} seconds ..."
            sleep delay
            counter = 0
          end
          counter += 1
          puts "(#{total += 1}/#{rpms.size}) Updating #{r.name}..."
          Rake::Task["fedora:import:rpm:bugs"].invoke(r.name)
          Rake::Task["fedora:import:rpm:bugs"].reenable
          Rake::Task["fedora:import:rpm:koji_builds"].invoke(r.name)
          Rake::Task["fedora:import:rpm:koji_builds"].reenable
          Rake::Task["fedora:import:rpm:commits"].invoke(r.name)
          Rake::Task["fedora:import:rpm:commits"].reenable
          Rake::Task["fedora:import:rpm:deps"].invoke(r.name)
          Rake::Task["fedora:import:rpm:deps"].reenable
          Rake::Task["fedora:import:rpm:gem"].invoke(r.name)
          Rake::Task["fedora:import:rpm:gem"].reenable
          puts "#{r.name} updated."
        end
      end
    end

    namespace :update do
      desc 'FEDORA | Update rpms metadata'
      task :rpms, [:age] => :environment do |t, args|
        args.with_defaults(age: 7)
        age = args[:age].to_i
        last_update = (Time.now - 60 * 60 * 24 * age).utc
        FedoraRpm.all.where('DATETIME(updated_at) < ?', last_update).each do |r|
          puts "Updating #{r.name}"
          r.update_from_source
          puts "#{r.name} updated."
        end
      end

      desc 'FEDORA | Update oldest <n> rpms'
      task :oldest_rpms, [:number] => :environment do |t, args|
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
  end
end

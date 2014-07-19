namespace :fedora do
  namespace :gem do
    namespace :import do

      desc 'FEDORA | Import a list of names of ALL gems from rubygems.org'
      task :all_names => :environment do
        gems = `gem list -r`.split("\n").collect { |g| g.split.first }
        gems.each do |gem_name|
          RubyGem.where(name: gem_name).first_or_create!
        end
        puts "Gems list of #{gems.size} imported."
      end

      desc 'FEDORA | Import gems metadata from rubygems.org'
      task :metadata, [:number, :delay] => :environment do |t, args|
        args.with_defaults(number: 100, delay: 5)
        total = 0
        counter = 0
        number_in_batch = args[:number].to_i
        delay = args[:delay].to_i
        gems = RubyGem.all
        gems.each do |g|
          if counter == number_in_batch
            puts "Delaying for #{delay} seconds ..."
            sleep delay
            counter = 0
          end
          counter += 1
          puts "Updating #{g.name} (#{total += 1}/#{gems.size}) ..."
          g.update_from_source
          puts "#{g.name} updated."
        end
      end
    end # :gem

    namespace :update do

      desc 'FEDORA | Update gems metadata from rubygems.org'
      task :gems, [:age] => :environment do |t, args|
        args.with_defaults(age: 7)
        age = args[:age].to_i
        last_update = (Time.now - 60 * 60 * 24 * age).utc
        RubyGem.all.where('DATETIME(updated_at) < ?', last_update).each do |g|
          puts "Updating #{g.name}"
          g.update_from_source
          puts "#{g.name} updated."
        end
      end
    end
  end # :update
end # :fedora

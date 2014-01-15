namespace :rubygems do

  desc 'Import a list of names of all gems from rubygem.org'
  task :import_names => :environment do
    gems = `gem list -r`.split("\n").collect { |g| g.split.first }
    gems.each do |gem_name|
      RubyGem.where(name: gem_name).first_or_create!
    end
    puts "Gems list of #{gems.size} imported."
  end

  desc 'Import gems from rubygems.org'
  task :import_gems, [:number, :delay] => :environment do |t, args|
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

  desc 'Update gems'
  task :update_gems, [:age] => :environment do |t, args|
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

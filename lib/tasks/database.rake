namespace :database do
  desc 'import gems from rubygems.org'
  task :import_gems, [:mode, :batch_number, :delay] => :environment do |t, args|
    # default import mode is 50 gems per batch, waiting for 10 seconds before next batch
    args.with_defaults(:mode => 'batch', :batch_number => 50, :delay => 10)

    if (args.mode == 'all')
      puts "Importing gems all together ..."
      GemImporter.import_all
    elsif (args.mode == 'top')
      puts "Importing top gems list ..."
      GemImporter.import_gems_list(:top)
    elsif (args.mode == 'refresh_list')
      puts "Importing gems list ..."
      GemImporter.import_gems_list
    elsif (args.mode == 'batch')
      batch_number = args.batch_number.to_i
      delay = args.delay.to_i
      if (batch_number > 0 && delay > 0)
        puts "Importing gems in batches ..."
        GemImporter.import_batch(batch_number, delay)
      else
        puts 'Missing/Invalid arguments'
      end
    end
  end

  desc 'import rpms from fedora'
  task :import_rpms, [:mode, :batch_number, :delay] => :environment do |t, args|
    # default import mode is 50 rpms per batch, waiting for 10 seconds before next batch
    args.with_defaults(:mode => 'batch', :batch_number => 50, :delay => 10)

    if (args.mode == 'all')
      puts "Importing rpms all together ..."
      RpmImporter.import_all
    elsif (args.mode == 'refresh_list')
      puts "Importing rpms list ..."
      RpmImporter.import_rpms_list
    elsif (args.mode == 'batch')
      batch_number = args.batch_number.to_i
      delay = args.delay.to_i
      if (batch_number > 0 && delay > 0)
        puts "Importing rpms in batches ..."
        RpmImporter.import_batch(batch_number, delay)
      else
        puts "Missing/Invalid arguments"
      end
    end
  end

  desc 'update rpms previously retrieved '
  task :update_rpms, [:days_since_last_update] => :environment do |t, args|
     args.with_defaults(:days_since_last_update => 7)
     unless args.days_since_last_update.nil? ||
            args.days_since_last_update.is_a?(Fixnum)
       raise ArgumentError, "invalid value for days since last update"
     end

     RpmImporter.update_rpms(args.days_since_last_update)
  end

  desc 'update gems previously retrieved '
  task :update_gems, [:days_since_last_update] => :environment do |t, args|
     args.with_defaults(:days_since_last_update => 7)
     unless args.days_since_last_update.nil? ||
            args.days_since_last_update.is_a?(Fixnum)
       raise ArgumentError, "invalid value for days since last update"
     end

     GemImporter.update_gems(args.days_since_last_update)
  end

end

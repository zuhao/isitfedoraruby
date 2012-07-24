namespace :database do
  desc 'import gems from rubygems.org'
  task :import_gems, [:mode, :batch_number, :delay] => :environment do |t, args|
    # default import mode is 50 gems per batch, waiting for 10 seconds before next batch
    args.with_defaults(:mode => 'batch', :batch_number => 50, :delay => 10)

    if (args.mode == 'all')
      puts "Importing gems all together ..."
      GemImporter.import_all
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
    # default import mode is 2 rpms per batch, waiting for 1 seconds before next batch
    # fedora server does not seem to be able to handle too much requests ...
    args.with_defaults(:mode => 'batch', :batch_number => 2, :delay => 1)

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

end

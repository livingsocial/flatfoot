namespace :flatfoot do

  desc "report used views"
  task :used => :environment do
    if FLATFOOT
      Flatfoot::Tracker.used_views
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

  desc "report unused views"
  task :unused => :environment do
    if FLATFOOT
      Flatfoot::Tracker.unused_views
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

  desc "reset tracked views"
  task :used => :environment do
    if FLATFOOT
      Flatfoot::Tracker.reset_recordings
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

end

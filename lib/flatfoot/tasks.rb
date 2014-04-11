namespace :flatfoot do

  desc "report used views"
  task :used => :environment do
    if FLATFOOT
      puts FLATFOOT.used_views.inspect
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

  desc "report unused views"
  task :unused => :environment do
    if FLATFOOT
      puts FLATFOOT.unused_views.inspect
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

  desc "reset tracked views"
  task :reset => :environment do
    if FLATFOOT
      puts FLATFOOT.reset_recordings.inspect
    else
      puts "please define a constant FLATFOOT with your Flatfoot::Tracker instance"
    end
  end

end

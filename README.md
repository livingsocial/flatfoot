# Flatfoot

[Flatfoot is a synonym for tracker](http://thesaurus.com/browse/tracker). As the name RenderTracker seemed generic, and gumshoe my favorite was taken.

This gem will help you track unused views in your application.

## Installation

Add this line to your application's Gemfile:

    gem 'flatfoot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flatfoot

## Usage

To use this gem, just initialize it in some initializer like `config/initializers/notifications.rb`

then create an instance and subscribe it to `ActiveSupport::Notifications` events.

    FLATFOOT = Flatfoot::Tracker.new(Redis.new)

	ActiveSupport::Notifications.subscribe /render_partial.action_view|render_template.action_view/ do |name, start, finish, id, payload|
	  FLATFOOT.track_views(name, start, finish, id, payload) unless name.include?('!') 
    end

Start up your app and then in console you can check used views or unused views

	FLATFOOT.used_views
	=> ["app/views/layouts/_flash.html.erb",...
	
	FLATFOOT.unused_views
    => ["app/views/something/_old_partial.html.erb",...

After making changes deploying or just to clear out the Redis size you can clear the saved data.

	FLATFOOT.reset_recordings

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

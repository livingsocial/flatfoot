require "flatfoot/version"

module Flatfoot
  
  class Tracker

    attr_accessor :store, :logged_views, :roots

    def initialize(store, options = {})
      @store = store
      @logged_views = []
      @roots = options.fetch(:roots){ "#{Rails.root.to_s}/" }.split(',')
    end
    
    def track_views(name, start, finish, id, payload)
      if file = payload[:identifier]
        unless logged_views.include?(file)
          logged_views << file
          store.sadd(tracker_key, file)
        end
      end
      ###
      # Annoyingly while you get full path for templates
      # notifications only pass part of the path for layouts dropping any format info
      # such as .html.erb or .js.erb
      # http://edgeguides.rubyonrails.org/active_support_instrumentation.html#render_partial-action_view
      ###
      if layout_file = payload[:layout]
        unless logged_views.include?(layout_file)
          logged_views << layout_file
          store.sadd(tracker_key, layout_file)
        end
      end
    end

    def used_views
      views = store.smembers(tracker_key)
      normalized_views = []
      views.each do |view|
             roots.each do |root|
                    view = view.gsub(/#{root}/,'')
                  end
             normalized_views << view
           end
      normalized_views
    end

    def unused_views
      all_views = Dir.glob('app/views/**/*.html.erb').reject{|file| file.match(/(_mailer)/)}
      recently_used_views = used_views
      all_views = all_views.reject{ |view| recently_used_views.include?(view) }
      # since layouts don't include format we count them used if they match with ANY formats
      all_views = all_views.reject{ |view| view.match(/\/layouts\//) && recently_used_views.any?{|used_view| view.include?(used_view)} }
    end

    def reset_recordings
      store.del(tracker_key)
    end

    private

    def tracker_key
      'render_tracker'
    end

  end

end

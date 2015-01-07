require "flatfoot/version"
require 'timeout'

module Flatfoot
  
  class Tracker

    DEFAULT_TARGET = Dir.glob('app/views/**/*.html.erb').reject{ |file| file.match(/(_mailer)/) }
    attr_accessor :store, :target, :logged_views, :roots

    def initialize(store, target = DEFAULT_TARGET, options = {})
      @store = store
      @target = target
      @logged_views = []
      @roots = options.fetch(:roots){ "#{Rails.root.to_s}/" }.split(',')
    end
    
    def track_views(name, start, finish, id, payload)
      begin
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
      rescue Errno::EAGAIN, Timeout::Error
        #we don't want to raise errors if flatfoot can't reach redis. This is a nice to have not a bring the system down
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
      recently_used_views = used_views
      all_views = target.reject{ |view| recently_used_views.include?(view) }
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

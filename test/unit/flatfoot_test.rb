require File.expand_path('../test_helper', File.dirname(__FILE__))

class ReporterTest < Test::Unit::TestCase

  should "init correctly" do
    tracker = Flatfoot::Tracker.new("store", {:roots => 'dir'})
    assert_equal 'dir', tracker.roots.first
    assert_equal 'store', tracker.store
    assert_equal [], tracker.logged_views
  end

  should "track partials" do
    store = fake_store
    store.expects(:sadd).with('render_tracker', 'file')
    tracker = Flatfoot::Tracker.new(store, {:roots => 'dir'})
    tracker.track_views('name', 'start', 'finish', 'id', {:identifier => 'file'})
    assert_equal ['file'], tracker.logged_views
  end

  should "track layouts" do
    store = fake_store
    store.expects(:sadd).with('render_tracker', 'layout')
    tracker = Flatfoot::Tracker.new(store, {:roots => 'dir'})
    tracker.track_views('name', 'start', 'finish', 'id', {:layout => 'layout'})
    assert_equal ['layout'], tracker.logged_views
  end

  should "report used partials" do
    store = fake_store
    tracker = Flatfoot::Tracker.new(store, {:roots => 'dir'})
    tracker.track_views('name', 'start', 'finish', 'id', {:identifier => 'file'})
    assert_equal ['file'], tracker.used_views
  end

  should "report unused partials" do
    store = fake_store
    Dir.expects(:glob).returns(['file', 'not_used'])
    tracker = Flatfoot::Tracker.new(store, {:roots => 'dir'})
    tracker.track_views('name', 'start', 'finish', 'id', {:identifier => 'file'})
    assert_equal ['not_used'], tracker.unused_views
  end

  should "reset store" do
    store = fake_store
    store.expects(:del).with('render_tracker')
    tracker = Flatfoot::Tracker.new(store, {:roots => 'dir'})
    tracker.track_views('name', 'start', 'finish', 'id', {:identifier => 'file'})
    tracker.reset_recordings
  end

  protected

  def fake_store
    store = OpenStruct.new(:del => true)
    store.data = []
    def store.sadd(key, val)
      data << val
    end
    def store.smembers(key)
      data
    end
    store
  end

end

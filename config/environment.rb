RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '..', 'vendor', 'plugins', 'thl_integration', 'lib', 'thl_cookie')

Rails::Initializer.run do |config|
  # config.gem 'fiveruns_tuneup'
  config.gem 'after_commit'
  config.plugins = [:acts_as_family_tree, :tiny_mce, :exception_notification, :places_engine, :all ]
  config.action_controller.session = {
    :session_key => ThlCookie.session_key,
    :secret      => ThlCookie.session_secret
  }
  # config.active_record.observers = :cached_category_count_sweeper
end
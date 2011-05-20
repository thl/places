RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

APP_DOMAIN = "places.thlib.org"
APP_NAME = "THL Places"
APP_URI = 'http://dev.places.thlib.org'

require File.join(File.dirname(__FILE__), 'boot')

if Gem::VERSION >= "1.3.6" 
module Rails
class GemDependency
def requirement
r = super
(r == Gem::Requirement.default) ? nil : r
end
end
end
end

Rails::Initializer.run do |config|
  # config.gem 'fiveruns_tuneup'
  config.gem 'after_commit'
  config.plugins = [:acts_as_family_tree, :tiny_mce, :exception_notification, :places_engine, :all ]
  config.action_controller.session = {
    :session_key => 'thl_session',
    :secret      => '92c58b72c968a9b8699f7f0e41491e82e4a1d3d671c628f880e1d6409e5eb4f2b4c7598f6544c5a7b96d175ecba6fac80b3d1507b735d7f710e13ffdb65b2842'
  }
  # config.active_record.observers = :cached_category_count_sweeper
end
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

APP_DOMAIN = "places.thlib.org"
APP_NAME = "THL Places"

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.gem 'fiveruns_tuneup'
  config.plugins = [:tiny_mce, :exception_notification, :places_engine, :all ]
  config.action_controller.session = { 
    :session_key => "_thdl_places_session", 
    :secret      => "Tibetan and Himalayan Digital Library - Places".reverse 
  }
end
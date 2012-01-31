if !defined? APP_DOMAIN && !defined? APP_URI
  hostname = Socket.gethostname.downcase
  if hostname == 'sds6.itc.virginia.edu'
    APP_DOMAIN = 'staging.places.thlib.org'
  elsif hostname == 'dev.thlib.org'
    APP_DOMAIN = 'dev.places.thlib.org'
  elsif hostname == 'e-bhutan.bt'
    APP_DOMAIN = 'www.e-bhutan.net.bt'
    APP_URI = "http://#{APP_DOMAIN}/places"
  elsif hostname.ends_with? 'local'
    APP_DOMAIN = 'localhost'
    APP_URI = "http://#{APP_DOMAIN}/places"
  else
    APP_DOMAIN = 'places.thlib.org'
  end
  APP_URI = "http://#{APP_DOMAIN}" if !defined? APP_URI
end
APP_NAME = "THL Places"
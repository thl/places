if !defined? APP_URI
  case InterfaceUtils::Server.environment
  when InterfaceUtils::Server::DEVELOPMENT
    APP_URI = "dev-places.#{InterfaceUtils::Server.get_domain}"
  when InterfaceUtils::Server::STAGING
    APP_URI = "staging-places.#{InterfaceUtils::Server.get_domain}"
  when InterfaceUtils::Server::PRODUCTION
    APP_URI = "places.#{InterfaceUtils::Server.get_domain}"
  when InterfaceUtils::Server::LOCAL
    APP_URI = 'localhost/thl/places'
  else
    APP_URI = "places.#{InterfaceUtils::Server.get_domain}"
  end
end
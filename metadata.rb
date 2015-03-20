name             "nginx_passenger"
maintainer       "Eric Richardson"
maintainer_email "e@ewr.is"
license          "BSD"
source_url       "https://github.com/ewr/nginx_passenger-cookbook"
issues_url       "https://github.com/ewr/nginx_passenger-cookbook/issues"
description      "Installs/Configures nginx and Passenger on Ubuntu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.4"

depends "apt"
depends "ssl_certificate"

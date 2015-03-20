name             "nginx_passenger"
maintainer       "Eric Richardson"
maintainer_email "e@ewr.is"
license          "BSD"
description      "Installs/Configures nginx and Passenger on Ubuntu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.3"

depends "apt"
depends "ssl_certificate"

default.nginx_passenger.sites_dir           = "/etc/nginx/sites-enabled"
default.nginx_passenger.nginx_workers       = 4

default.nginx_passenger.log_dir             = "/var/log/nginx"
default.nginx_passenger.cert_dir            = "/etc/nginx/certs"
default.nginx_passenger.ruby                = "/usr/bin/ruby"
default.nginx_passenger.max_pool_size       = 8

default.nginx_passenger.cert_databag        = "ssl_certs"

default.nginx_passenger.redirect_to_https   = true
default.nginx_passenger.site_min_instances  = 2
default.nginx_passenger.site_max_body_size  = "8M"

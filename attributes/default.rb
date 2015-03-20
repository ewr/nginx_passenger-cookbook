default.nginx_passenger.use_passenger_4     = false

default.nginx_passenger.sites_dir           = "/etc/nginx/sites-enabled"
default.nginx_passenger.nginx_workers       = 4
default.nginx_passenger.catch_default       = false

default.nginx_passenger.log_dir             = "/var/log/nginx"
default.nginx_passenger.certs_dir           = "/etc/nginx/certs"
default.nginx_passenger.ruby                = "/usr/bin/ruby"
default.nginx_passenger.max_pool_size       = 8

default.nginx_passenger.cert_databag        = "ssl_certs"
default.nginx_passenger.cert_authority      = "Self Signed"

default.nginx_passenger.redirect_to_https   = true
default.nginx_passenger.site_min_instances  = 2
default.nginx_passenger.site_max_body_size  = "8M"
default.nginx_passenger.keep_env_path       = true
default.nginx_passenger.default_log_format  = "combined"

default.nginx_passenger.maintenance_page    = nil
default.nginx_passenger.maintenance_check   = nil

---
                 _           ______                                        
                (_)          | ___ \                                       
     _ __   __ _ _ _ __ __  _| |_/ /_ _ ___ ___  ___ _ __   __ _  ___ _ __ 
    | '_ \ / _` | | '_ \\ \/ /  __/ _` / __/ __|/ _ \ '_ \ / _` |/ _ \ '__|
    | | | | (_| | | | | |>  <| | | (_| \__ \__ \  __/ | | | (_| |  __/ |   
    |_| |_|\__, |_|_| |_/_/\_\_|  \__,_|___/___/\___|_| |_|\__, |\___|_|   
            __/ |                                           __/ |          
           |___/                                           |___/           
---

This cookbook installs nginx and [Passenger](https://www.phusionpassenger.com/) 
using packages compiled by Phusion.  If you want to do extensive nginx 
configuration, you may want to use the Opscode 
[nginx cookbook](https://github.com/opscode-cookbooks/nginx) instead.


Currently the cookbook is only written for Ubuntu, since it assumes apt for 
package install.

The default recipe adds the Phusion repository and installs the passenger and 
nginx packages.

## `nginx_passenger_site`

The `nginx_passenger_site` resource is used to add a Passenger-enabled site 
to nginx.

For instance:

    nginx_passenger_site "ewr" do
      action :create
      dir    "/web/ewr/current"
      server "ewr.is"
    end
    
That call would create an nginx config file at `/etc/nginx/sites-enabled/ewr` 
pointing to an app installed at `/web/ewr/current`.  Because it's Passenger, 
the nginx root is actually set to `/web/ewr/current/public`.  

There are several other attributes that can be set on the resource:

* __name:__ The site key.  "ewr" in the example above.
* __dir:__ The base directory for the application.
* __server:__ The nginx `server_name`
* __rails_env:__ Set the Passenger `rails_env` setting
* __cert:__ Key that specifies an SSL certificate that should be downloaded 
    and installed for the app.  Uses a databag specified in 
    `node.nginx_passenger.cert_databag`.
* __http:__ Should HTTP be supported?  If no cert is provided, the answer 
    will be yes, regardless of the value of this flag.  If a cert is provided
    (and HTTPS is therefore enabled), this setting determines whether the 
    app should also be served up over HTTP.  If not, you can optionally have 
    HTTP access redirect to HTTPS based on the value of 
    `node.nginx_passenger.redirect_to_https`.
* __template:__ If you would like to specify custom nginx / Passenger 
    configuration, you can specify its name here.  By default, the resource 
    will use a stock config that is included.
* __min_instances:__ Passenger's `passenger_min_instances` setting.  By default, 
    set to the value of `node.nginx_passenger.site_min_instances`, which ships as 
    to 2.
* __max\_body\_size:__ Nginx `client_max_body_size` setting.  Defaults to 
    `node.nginx_passenger.site_max_body_size`, which ships as '8M' (8 megabytes).
    
## Who

This cookbook was written by [Eric Richardson](http://ewr.is), loosely based on 
practices developed putting together cookbooks for [Emcien](http://emcien.com).

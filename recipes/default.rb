# Installs nginx and Passenger from Phusion's oss-binaries repo

include_recipe "apt"

# -- Make sure apt HTTPS is installed -- #

package "apt-transport-https"

# -- Add repo -- #

apt_repository "phusion" do
  action        :add
  uri           "https://oss-binaries.phusionpassenger.com/apt/passenger"
  distribution  node.lsb.codename
  components    ['main']
  keyserver     "keyserver.ubuntu.com"
  key           "561F9B9CAC40B2F7"
end

# -- Install packages -- #

package "nginx-common" do
  options '-o DPkg::Options::="--force-confold"'
end

package "passenger"
package "nginx-extras"

# -- Define a service we can use later -- #

service "nginx" do
  action    [:enable,:start]
  supports  [:enable,:start,:stop,:disable,:reload,:restart]
end

# -- Install nginx config with Passenger -- #

template "/etc/nginx/nginx.conf" do
  action :create
  notifies :restart, "service[nginx]"
end

# -- Make sure sites directory exists -- #

directory node.nginx_passenger.sites_dir do
  action      :create
  recursive   true
  mode        0755
end

# -- Make sure logs directory exists -- #

directory node.nginx_passenger.log_dir do
  action :create
  recursive true
  mode 0755
  owner "www-data"
end

# -- Should we create an empty default site? -- #

template "#{node.nginx_passenger.sites_dir}/DEFAULT" do
  action node.nginx_passenger.catch_default ? :create : :delete
  notifies :reload, "service[nginx]"
end
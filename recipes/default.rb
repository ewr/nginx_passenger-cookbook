# Installs nginx and Passenger from Phusion's oss-binaries repo

include_recipe "apt"

# -- Make sure apt HTTPS is installed -- #

package "apt-transport-https"

# -- Add repo -- #

# if the enterprise token is set choose the enterprise repo, else use OSS
if node.nginx_passenger.enterprise_token
  apt_uri = "https://download:#{node.nginx_passenger.enterprise_token}@www.phusionpassenger.com/enterprise_apt"
else
  apt_uri = "https://oss-binaries.phusionpassenger.com/apt/passenger"
end

# Phusion provides two repos: one that contains Passenger 5, and one that
# contains Passenger 4. Use the appropriate one based on the
# `nginx_passenger.use_passenger_4` attribute boolean
if node.nginx_passenger.use_passenger_4
  apt_uri = "#{apt_uri}/4"
end

apt_repository "phusion" do
  action        :add
  uri           apt_uri
  distribution  node.lsb.codename
  components    ['main']
  keyserver     "hkp://keyserver.ubuntu.com:80"
  key           "561F9B9CAC40B2F7"
end

# -- Install packages -- #

package "nginx-common" do
  options '-o DPkg::Options::="--force-confold"'
end

if node.nginx_passenger.enterprise_token
  package "passenger-enterprise"
else
  package "passenger"
end
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

# -- Install passenger enterprise license -- #
if node.nginx_passenger.enterprise_license
  remote_file "/etc/passenger-enterprise-license" do
    source node.nginx_passenger.enterprise_license
    mode '644'
  end
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
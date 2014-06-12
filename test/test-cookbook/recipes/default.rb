# Create the directory for our web server
directory "/web/test/current/public" do
  owner     "www-data"
  group     "www-data"
  mode      0755
  action    :create
  recursive true
end

# Create the default test site
nginx_passenger_site "test" do
  action        :create
  server        "localhost"
  cert          "skip"
  dir           "/web/test/current"
end

# Create a site to test maintenance mode
nginx_passenger_site "maintenance-mode-test" do
  action            :create
  server            "maintenance-mode-test"
  cert              "skip"
  dir               "/web/test/current"
  maintenance_check "/web/test/current/public/maintenance.html"
  maintenance_page  "/maintenance.html"
end

# Create our index.html page
template "/web/test/current/public/index.html" do
  action :create
  notifies :restart, "service[nginx]"
  mode      0644
  group     "www-data"
  owner     "www-data"
end

# Create our maintenance.html page
template "/web/test/current/public/maintenance.html" do
  action :create
  notifies :restart, "service[nginx]"
  mode      0644
  group     "www-data"
  owner     "www-data"
end

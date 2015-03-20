# for the test suite...
package "curl"

# -- Create working test site -- #

# Create the directory for our web server
['/web/test','/web/test/public'].each do |d|
  directory d do
    owner     "www-data"
    group     "www-data"
    mode      0755
    action    :create
    recursive true
  end
end

template "/web/test/config.ru" do
  action    :create
  owner     "www-data"
  group     "www-data"
  mode      0755
  variables({ :server => "test.kitchen" })
end

# Create the default test site
nginx_passenger_site "test" do
  action        :create
  server        "test.kitchen"
  cert          "skip"
  dir           "/web/test"
  log_format    "combined_timing"
end

# -- Create site with a self-signed cert -- #

# Create the directory for our web server
['/web/certtest','/web/certtest/public'].each do |d|
  directory d do
    owner     "www-data"
    group     "www-data"
    mode      0755
    action    :create
    recursive true
  end
end

template "/web/certtest/config.ru" do
  action    :create
  owner     "www-data"
  group     "www-data"
  mode      0755
  variables({ :server => "certtest.kitchen" })
end

# Create the default test site
nginx_passenger_site "certtest" do
  action        :create
  server        "certtest.kitchen"
  generate_cert true
  dir           "/web/certtest"
  log_format    "combined_timing"
end

# -- Create maintenance mode site -- #

# Create the directory for our web server
['/web/maintenance','/web/maintenance/public'].each do |d|
  directory d do
    owner     "www-data"
    group     "www-data"
    mode      0755
    action    :create
    recursive true
  end
end

# write our maintenance mode flag
file "/web/maintenance/IN_MAINTENANCE_MODE" do
  action :touch
  owner "www-data"
  group "www-data"
end

# Create our foo.html page
file "/web/maintenance/public/foo.txt" do
  action :create
  mode      0644
  group     "www-data"
  owner     "www-data"
  content   "BAR\n"
end

# Create our maintenance.html page
template "/web/maintenance/public/maintenance.html" do
  action :create
  mode      0644
  group     "www-data"
  owner     "www-data"
end

template "/web/maintenance/config.ru" do
  action    :create
  owner     "www-data"
  group     "www-data"
  mode      0755
  variables({ :server => "maintenance.kitchen" })
end

nginx_passenger_site "maintenance" do
  action            :create
  server            "maintenance.kitchen"
  cert              "skip"
  dir               "/web/maintenance"
  maintenance_page  "/maintenance.html"
end

# -- Create static site -- #

# Create the directory for our web server
['/web/static'].each do |d|
  directory d do
    owner     "www-data"
    group     "www-data"
    mode      0755
    action    :create
    recursive true
  end
end

file "/web/static/index.html" do
  action :create
  content "<html><head><title>Testing</title></head><body><h1>Testing Static!</h1></body></html>"
end

# Create the default test site
nginx_passenger_site "static" do
  action        :create
  server        "static.kitchen"
  cert          "skip"
  dir           "/web/static"
  log_format    "combined_timing"
  static        true
end
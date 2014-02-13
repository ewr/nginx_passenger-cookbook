require "spec_helper"

# nginx should be running
describe service("nginx") do
  it { should be_running }
end

# nginx config should point to the sites dir
describe file("/etc/nginx/nginx.conf") do
  it { should be_file }
  its(:content) { should include("include /etc/nginx/sites/*;") }
end

# make sure the sites dir exists

describe file("/etc/nginx/sites") do
  it { should be_directory }
  #it { should be_owned_by("www-data") }
end

# make sure the logs dir exists

describe file("/var/log/nginx-sites") do
  it { should be_directory }
  it { should be_owned_by("www-data") }
end


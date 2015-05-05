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

# -- test working site -- #

describe command("curl -H 'Host: test.kitchen' http://localhost") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("OK! test.kitchen") }
end

# check for timing information on the access log
describe command("tail -1 /var/log/nginx-sites/test.access.log") do
  its(:stdout) { should match(/" [\d\.]+ [\d\.]+ \.$/) }
end

# -- test self-signed cert site -- #

describe command("curl -k -v -H 'Host: certtest.kitchen' https://localhost") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("OK! certtest.kitchen") }
  its(:stdout) { should include("subject: O=Self Signed") }
end

# -- test maintenance site -- #

describe command("curl -H 'Host: maintenance.kitchen' localhost") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("Under Construction") }
end

describe command("curl -H 'Host: maintenance.kitchen' http://localhost/foo.txt") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("BAR") }
end

# there should be no timing data here...
describe command("tail -1 /var/log/nginx-sites/maintenance.access.log") do
  its(:stdout) { should match(/"$/) }
end

# -- test static site -- #

describe command("curl -H 'Host: static.kitchen' localhost") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("Testing Static!") }
end

# -- test IP for 404 (catch default) -- #

describe command("curl localhost") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include("404 Not Found") }
end


# Installs nginx and Passenger from Phusion's oss-binaries repo

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

package "passenger"
package "nginx-extras"

# -- Define a service we can use later -- #

service "nginx" do
  action    [:enable,:start]
  supports  [:enable,:start,:stop,:disable,:reload,:restart]
end
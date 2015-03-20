action :create do
  # -- Are we installing an SSL site? -- #

  cert_exists = false

  if (new_resource.cert && new_resource.cert != "skip") || new_resource.generate_cert
    directory node.nginx_passenger.certs_dir do
      action :create
      recursive true
    end
  end

  if new_resource.cert && new_resource.cert != "skip"
    # Look up SSL cert in databag
    cert = data_bag_item(node.nginx_passenger.cert_databag,new_resource.cert)

    if cert
      # TODO: Need to make sure cert has cert and key

      cert.keys.each do |k|
        file "#{node.nginx_passenger.certs_dir}/#{new_resource.name}.#{k}" do
          backup    1
          mode      0644
          content   cert[k]
          notifies  :reload, "service[nginx]"
        end
      end

      cert_exists = true

    else
      # need to error that the specified SSL cert wasn't found
    end
  end

  if new_resource.generate_cert

    ssl_certificate new_resource.server do
      action :create
      organization node.nginx_passenger.cert_authority
      key_path "#{node.nginx_passenger.certs_dir}/#{new_resource.name}.key"
      cert_path "#{node.nginx_passenger.certs_dir}/#{new_resource.name}.cert"
      source "self-signed"
    end

    cert_exists = true

  end

  # -- Create nginx site file -- #

  log_format = new_resource.log_format || node.nginx_passenger.default_log_format

  template "#{node.nginx_passenger.sites_dir}/#{new_resource.name}" do
    if new_resource.template
      source new_resource.template
    else
      source "site.conf.erb"
      cookbook "nginx_passenger"
    end

    mode 0644

    variables({:resource => new_resource,:cert_exists => cert_exists,:log_format => log_format})

    notifies :reload, "service[nginx]"
  end
end

#----------

action :delete do
  # -- Define nginx service (just in case) -- #

  service "nginx" do
    provider  Chef::Provider::Service::Upstart
    action    :nothing
    supports  :start => true, :restart => true, :reload => true
  end

  # -- Delete nginx site file -- #

  file "#{node.nginx_passenger.sites_dir}/#{new_resource.name}" do
    action :delete
    notifies :reload, "service[nginx]", :immediately
  end

  # -- Delete any certs -- #

  execute "remove-#{new_resource.name}-certs" do
    command "rm -f #{node.nginx_passenger.certs_dir}/#{new_resource.name}*"
    action :run
  end
end
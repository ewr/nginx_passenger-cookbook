action :create do
  # -- Are we installing an SSL site? -- #
  
  cert_exists = false
  
  if new_resource.cert && new_resource.cert != "skip"
    # Look up SSL cert in databag
    cert = data_bag_item(node.nginx_passenger.cert_databag,new_resource.cert)
    
    if cert
      # TODO: Need to make sure cert has cert and key
      
      directory node.nginx_passenger.certs_dir do
        action :create
        recursive true
      end
      
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
  
  # -- Create nginx site file -- #
    
  template "#{node.nginx_passenger.sites_dir}/#{new_resource.name}" do
    if new_resource.template
      source new_resource.template
    else
      source "site.conf.erb"
      cookbook "nginx_passenger"
    end
    
    mode 0644
    
    variables({:resource => new_resource,:cert_exists => cert_exists})
    
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
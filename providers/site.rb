action :install do
  # -- Are we installing an SSL site? -- #
  
  cert_exists = false
  
  if new_resource.cert && new_resource.cert != "skip"
    # Look up SSL cert in databag
    cert = data_bag_item(node.nginx_passenger.cert_databag,new_resource.cert)
    
    if cert
      # TODO: Need to make sure cert has cert and key
      # TODO: Should certs dir be an attribute?
      
      directory "/etc/nginx/certs" do
        action :create
      end
      
      cert.keys.each do |k|
        file "/etc/nginx/certs/#{new_resource.name}.#{k}" do
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
  
  template "/etc/nginx/sites-enabled/#{new_resource.name}" do
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
actions :delete
default_action :create
attribute :name,              :kind_of => String
attribute :server,            :kind_of => String
attribute :rails_env,         :kind_of => String
attribute :dir,               :kind_of => String
attribute :ruby,              :kind_of => String
attribute :cert,              :kind_of => String
attribute :generate_cert,     :kind_of => [TrueClass,FalseClass], :default => false
attribute :http,              :kind_of => [TrueClass,FalseClass], :default => false
attribute :template,          :kind_of => String
attribute :min_instances,     :kind_of => Integer
attribute :max_body_size,     :kind_of => String
attribute :env,               :kind_of => String
attribute :user,              :kind_of => String
attribute :custom,            :kind_of => Hash
attribute :maintenance_page,  :kind_of => String
attribute :maintenance_check, :kind_of => String
attribute :log_format,        :kind_of => String
attribute :static,            :kind_of => [TrueClass,FalseClass], :default => false
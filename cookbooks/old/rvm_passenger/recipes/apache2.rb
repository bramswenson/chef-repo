include_recipe "apache2"

if platform?("centos","redhat")
  package "httpd-devel"
else
  %w{ apache2-prefork-dev libapr1-dev }.each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end

rvm_passenger_apache2 node.rvm_passenger[:ruby] do
  action :install
end



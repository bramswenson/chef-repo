include RvmLibrary

action :install do
  
  
  # base gem install into global
  rvm_passenger_install new_resource.name do
    action :install
    version new_resource.version if new_resource.version
  end

  # gem install into current gemset for api


  rvm_gem "SyslogLogger" do
    action :install
    ruby new_resource.ruby
  end


#  template run_context.node[:passenger][:apache_load_path] do
#    source "passenger.load.erb"
#    owner "root"
#    group "root"
#    mode 0755
#    notifies :restart, resources(:service => "apache2")
#  end
#
#  template run_context.node[:passenger][:apache_conf_path] do
#    source "passenger.conf.erb"
#    owner "root"
#    group "root"
#    mode 0755
#    notifies :restart, resources(:service => "apache2")
#  end
#
#  remote_file "/usr/local/bin/passenger_monitor" do
#    source "passenger_monitor"
#    mode 0755
#  end
#
#  cron "passenger memory monitor" do
#    command "/usr/local/bin/passenger_monitor #{node[:passenger][:soft_memory_limit]} #{node[:passenger][:hard_memory_limit]}"
#  end
#
#  run_context.apache_module "passenger"
#  run_context.include_recipe "apache2::mod_deflate"
#  run_context.include_recipe "apache2::mod_rewrite"
#
end

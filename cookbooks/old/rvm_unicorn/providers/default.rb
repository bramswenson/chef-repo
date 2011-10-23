action :deploy do
  this_resource = new_resource
  rvm_gem "unicorn" do
    action :install
    ruby this_resource.ruby
  end


  directory new_resource.name do
    recursive true
    action :create
    owner new_resource.user
    group new_resource.group
  end

  template "#{new_resource.name}/unicorn_config.rb" do
    source "unicorn.rb.erb"
    cookbook "rvm_unicorn"
    mode "0644"
    owner this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    mode this_resource.mode   if this_resource.mode
    variables this_resource.to_hash
    notifies *this_resource.notifies if this_resource.notifies
  end

  template "#{new_resource.name}/unicornctl" do
    source "unicornctl.erb"
    cookbook "rvm_unicorn"
    mode "0755"
    owner this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    mode this_resource.mode   if this_resource.mode
    variables this_resource.to_hash
    notifies *this_resource.notifies if this_resource.notifies
  end

  service "unicorn_#{new_resource.name}" do
    action :start
    running true
    start_command "#{new_resource.name}/unicornctl start"
    stop_command "#{new_resource.name}/unicornctl stop"
    status_command "#{new_resource.name}/unicornctl status"
    restart_command "#{new_resource.name}/unicornctl restart"
    reload_command "#{new_resource.name}/unicornctl reload"
    pattern "#{new_resource.name}/unicorn.sock"
    supports :restart => true, :reload => true, :status => true, :start => true, :stop => true
  end

end

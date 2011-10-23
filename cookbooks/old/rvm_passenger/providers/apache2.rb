include RvmLibrary
action :install do
  ruby_name, gemset = split_ruby_gemset(new_resource.name) 
  rvm_passenger new_resource.name do
    action :install
  end

  rvm_shell "build passenger module for apache in ruby #{new_resource.name}" do
    action :run
    ruby ruby_name
    code %Q{ passenger-install-apache2-module -a }
    # FIXME: hard coded path
    not_if %Q{ test -f "/usr/local/rvm/gems/ree-1.8.7-2010.02@global/gems/passenger-3.0.2/ext/apache2/mod_passenger.so" }
  end
end

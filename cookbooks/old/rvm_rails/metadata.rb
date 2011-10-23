maintainer       "Bram Swenson"
maintainer_email "bram@craniumisajar.com"
license          "Apache 2.0"
description      "Installs/Configures rvm_rails"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ rvm rvm_passenger rvm_unicorn nginx }.each do |cb|
  depend cb
end

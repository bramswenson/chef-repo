maintainer       "Bram Swenson"
maintainer_email "bram@craniumisajar.com"
license          "Apache 2.0"
description      "Installs/Configures potsdam"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ rvm rvm_rails }.each do |cb|
  depends cb
end

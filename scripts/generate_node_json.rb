#!/usr/bin/env ruby

def ask(message, default=nil)
  message = "#{message} (#{default})" if default
  puts message
  value = gets.chomp
  value = nil if value == ''
  return default.nil? ? value : (value || default)
end

def ask_hostname
  hostname = %x( hostname --fqdn ).chomp
  return ask("What is the hostname?", hostname)
end

def ask_nameservers
  nameservers = '8.8.8.8 8.8.4.4'
  return ask("What are the nameservers?", nameservers).split(' ')
end

hostname = ask_hostname
domain = hostname.split('.')[-2..-1].join('.')
nameservers = ask_nameservers.map do |ns|
  "\"#{ns}\""
end.join(', ')
content = <<EOJSON
{
  "resolver": {
    "nameservers": [ #{nameservers} ],
    "search":"#{domain}"
  },
  "run_list": [ "recipe[resolver]" ]
}
EOJSON

File.open('/srv/chef-solo/node.json','w') do |f|
  f.write(content)
end

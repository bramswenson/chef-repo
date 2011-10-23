action :install do
  %w( build-essential libxml2-dev libxslt1-dev libssl-dev libcurl4-openssl-dev libreadline-dev zlib1g-dev ).each do |pkg|
    package pkg
  end
  case new_resource.version
    when '1.9.2-p290'
  end
  rbenv_shell "rbenv install #{new_resource.name}" do
    action :run
    user new_resource.user
    group new_resource.user
    code <<-CODE
rbenv install #{new_resource.version}
CODE
    not_if "$HOME/.rbenv/bin/rbenv versions | grep #{new_resource.version}"
  end
end

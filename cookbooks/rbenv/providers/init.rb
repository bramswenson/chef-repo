action :init do
  bash "rbenv init #{new_resource.name}" do
    user new_resource.user
    group new_resource.user
    code <<-CODE
cp -a #{node[:rbenv][:src_path]} #{new_resource.path}
chown -R #{new_resource.user}: #{new_resource.path}
chmod -R 755 #{new_resource.path}
CODE
    not_if { ::File.directory?(new_resource.path) }
  end
  bash "rbenv setup #{new_resource.name}" do
    user new_resource.user
    group new_resource.user
    code <<CODE
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc
CODE
    not_if  "cat $HOME/.bashrc | grep rbenv"
  end
end

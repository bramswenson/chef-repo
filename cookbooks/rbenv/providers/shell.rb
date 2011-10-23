action :run do
  rbenv_shell_code = <<-CODE
sudo -u #{new_resource.user} bash -l -c ' \
export PATH="$HOME/.rbenv/bin:$PATH" && \
eval "$(rbenv init -)" && \
#{new_resource.version.nil? ? '' :
"rbenv shell --unset && \
rbenv shell #{new_resource.version} && \ "}
#{new_resource.code||new_resource.command}'
CODE
  bash "rbenv shell #{new_resource.command}" do
    code  rbenv_shell_code
    cwd   new_resource.cwd unless new_resource.cwd.nil?
    user  new_resource.user
    group new_resource.group || new_resource.user
  end
end

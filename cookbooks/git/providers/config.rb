action :install do
  home_path = %x( su - #{new_resource.user} -c "echo $HOME" ).chomp
  template "#{home_path}/.gitconfig" do
    action :create_if_missing
    cookbook 'git'
    source 'gitconfig.erb'
    owner new_resource.user
    group new_resource.group || new_resource.user
    mode 0644
    variables({
      :git_name => new_resource.git_name,
      :git_email => new_resource.git_email,
      :github_user => new_resource.github_user,
      :github_token => new_resource.github_token,
      :editor => new_resource.editor
    })
  end
end

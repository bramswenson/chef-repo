#
# Cookbook Name:: stackspin
# Recipe:: utilities
#
# Copyright 2011, Bram Swenson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require_recipe 'git'
require_recipe 'byobu'
require_recipe 'vim-gnome'
require_recipe 'vimpack'
package 'htop'

home_path = node[:stackspin][:home_path]

bash 'vimpack-init' do
  code <<CODE
sudo su - stackspin -c 'vimpack init git://github.com/bramswenson/vimpack-repo.git'
CODE
  user 'stackspin'
  group 'stackspin'
  cwd home_path
  environment {{ 'HOME' => home_path }}
  not_if { File.directory?(File.join(home_path, '.vimpack')) }
end


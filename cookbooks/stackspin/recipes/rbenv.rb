#
# Cookbook Name:: stackspin
# Recipe:: rbenv
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
#
require_recipe 'rbenv'

home_path = node[:stackspin][:home_path]

rbenv_init 'stackspin' do
  action :init
  user 'stackspin'
  path File.join(home_path, '.rbenv')
end

rbenv_install 'stackspin' do
  action :install
  user 'stackspin'
  version '1.9.2-p290'
end

rbenv_shell 'test' do
  action :run
  user 'stackspin'
  group 'stackspin'
  version '1.9.2-p290'
  code 'ruby -v'
end

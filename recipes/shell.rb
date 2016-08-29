#
# Cookbook Name:: fenton_integration_test
# Recipe:: shell
#
# Copyright 2016 Nick Willever
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.override['fenton_integration_test']['ruby_version'] = version = '2.2.3'
node.override['fenton_integration_test']['folder'] = '/fenton_shell'
fenton_tk_machine = node['fenton_integration_test']['tkmachine']

include_recipe "#{cookbook_name}::install_ruby"

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '070'
  action :create
end

file '/root/.ssh/config' do
  content <<-EOH
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
  EOH
end

execute 'run workflow' do
  cwd '/fenton_shell'
  user 'root'
  group 'root'
  environment({"HOME" => "/root", "USER" => "root"})
  command <<-EOH
    rm -Rf ~/.ssh/id_rsa ~/.fenton
    bash -l -c 'rvm use #{version}; bundle exec ./bin/fenton key generate --private_key ~/.ssh/id_rsa --passphrase foobar && \
    bundle exec ./bin/fenton --fenton_server_url #{fenton_base_url} client signup foobar --name "Foo Bar" \
      --email "foo.bar@example.com" --password foobar --public_key ~/.ssh/id_rsa.pub && \
    bundle exec ./bin/fenton project create Test Kitchen Machine --key tkmachine --description "My lonely test kitchen machine" \
      --passphrase foobar && \
    bundle exec ./bin/fenton key sign --project tkmachine'
  EOH
  live_stream true
end

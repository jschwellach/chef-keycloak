#
# Cookbook Name:: keycloak
# Recipe:: extract
#
# Copyright (C) 2018 Rodel Talampas
# Update for the Keycloak cookbook from Janos Schwellach (https://github.com/jschwellach/chef-keycloak)
# based on the wildfly cookbook from Brian Dwyer (https://github.com/bdwyertech/chef-wildfly)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#
# This recipe will install keycloak without doing template configuration.
# It will make use of keycloak's standalone.xml or standalone-ha.xml
#

# => Shorten Hashes
wildfly = node['wildfly']

# => Update System
include_recipe 'apt' if platform?('ubuntu', 'debian')
include_recipe 'yum' if platform_family?('rhel')

# Create file to indicate user upgrade change (Applicable to 0.1.16 to 0.1.17 upgrade)
file ::File.join(wildfly['base'], '.chef_useracctchange') do
  action :touch
  only_if { ::File.exist?(::File.join(wildfly['base'], '.chef_deployed')) && shell_out("getent passwd #{wildfly['user']}").stdout.split(':')[5] != wildfly['base'] }
  notifies :stop, "service[#{wildfly['service']}]", :immediately
end

# => Create Wildfly System User
user wildfly['user'] do
  comment 'Wildfly System User'
  home wildfly['base']
  shell '/sbin/nologin'
  system true
  action [:create, :lock]
end

# => Create Wildfly Group
group wildfly['group'] do
  append true
  members wildfly['user']
  action :create
  only_if { wildfly['user'] != wildfly['group'] }
end

# => Create Wildfly Directory
directory wildfly['base'] do
  owner wildfly['user']
  group wildfly['group']
  mode '0755'
  recursive true
end

# => Ensure LibAIO Present for Java NIO Journal
case node['platform_family']
when 'rhel'
  package 'libaio' do
    action :install
  end
when 'debian'
  package 'libaio1' do
    action :install
  end
end

# => Download Wildfly Tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{wildfly['version']}.tar.gz" do
  source wildfly['url']
  checksum wildfly['checksum']
  action :create
  notifies :run, 'bash[Extract Keycloak]', :immediately
end

# => Extract Keycloak
bash 'Extract Keycloak' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar xzf #{wildfly['version']}.tar.gz -C #{wildfly['base']} --strip 1
  chown #{wildfly['user']}:#{wildfly['group']} -R #{wildfly['base']}
  rm -f #{::File.join(wildfly['base'], '.chef_deployed')}
  EOF
  action :nothing
end

# Deploy Init Script
template ::File.join(::File::SEPARATOR, 'etc', 'init.d', wildfly['service']) do
  case node['platform_family']
  when 'rhel'
    source 'wildfly-init-redhat.sh.erb'
  when 'debian'
    source 'wildfly-init-debian.sh.erb'
  end
  user 'root'
  group 'root'
  mode '0755'
  cookbook 'wildfly'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately if node['init_package'] == 'systemd'
end

execute 'systemctl daemon-reload' do
  action :nothing
end

# Deploy Service Configuration
template ::File.join(::File::SEPARATOR, 'etc', 'default', 'wildfly.conf') do
  source 'wildfly.conf.erb'
  user 'root'
  group 'root'
  mode '0644'
  cookbook 'wildfly'
end

# => Configure Wildfly Standalone - MGMT Users
template ::File.join(wildfly['base'], 'standalone', 'configuration', 'mgmt-users.properties') do
  source 'mgmt-users.properties.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  variables(
    mgmt_users: wildfly['users']['mgmt']
  )
  cookbook 'wildfly'
end

# => Configure Wildfly Domain - MGMT Users
template ::File.join(wildfly['base'], 'domain', 'configuration', 'mgmt-users.properties') do
  source 'mgmt-users.properties.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0600'
  variables(
    mgmt_users: wildfly['users']['mgmt']
  )
  only_if { wildfly['mode'] == 'domain' }
  cookbook 'wildfly'
end

# => Start the Wildfly Service
service wildfly['service'] do
  action [:enable, :start]
end

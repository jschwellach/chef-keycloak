#
# Cookbook Name:: keycloak
# Recipe:: install
#
# Copyright (C) 2016 Janos Schwellach
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

# => Shorten Hashes
wildfly = node['wildfly']

include_recipe 'wildfly::install'

begin
  r = resources(template: ::File.join(wildfly['base'], 'standalone', 'configuration', wildfly['sa']['conf']))
  r.cookbook 'keycloak'
  r.source "standalone-keycloak.xml.#{node['wildfly']['version']}.erb"
  r.mode '0755'
  r.variables(
    port_binding_offset: wildfly['int']['port_binding_offset'],
    mgmt_int: wildfly['int']['mgmt']['bind'],
    mgmt_http_port: wildfly['int']['mgmt']['http_port'],
    mgmt_https_port: wildfly['int']['mgmt']['https_port'],
    pub_int: wildfly['int']['pub']['bind'],
    pub_http_port: wildfly['int']['pub']['http_port'],
    pub_https_port: wildfly['int']['pub']['https_port'],
    wsdl_int: wildfly['int']['wsdl']['bind'],
    ajp_port: wildfly['int']['ajp']['port'],
    smtp_host: wildfly['smtp']['host'],
    smtp_port: wildfly['smtp']['port'],
    smtp_ssl: wildfly['smtp']['ssl'],
    smtp_user: wildfly['smtp']['username'],
    smtp_pass: wildfly['smtp']['password'],
    acp: wildfly['acp'],
    s3_access_key: wildfly['aws']['s3_access_key'],
    s3_secret_access_key: wildfly['aws']['s3_secret_access_key'],
    s3_bucket: wildfly['aws']['s3_bucket']
  )
  r.notifies :restart, "service[#{wildfly['service']}]", :delayed
  r.only_if { !::File.exist?(::File.join(wildfly['base'], '.chef_deployed')) || wildfly['enforce_config'] }
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'could not find template to override!'
end

#
# Cookbook Name:: keycloak
# Recipe:: configuration
#
# Modified by (C) 2018 Rodel M. Talampas
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

if node['wildfly']['force']['config']
  node['wildfly']['system_properties'].each do |property|
    wildfly_property "create_#{property['name']}" do
      property property['name']
      value property['value']
      instance 'keycloak'
      action %i[delete set]
      notifies :restart, 'service[keycloak]', :delayed
    end
  end

  node['wildfly']['postgresql']['jndi']['datasources'].each do |source|
    wildfly_datasource source['pool_name'] do
      dsname source['pool_name']
      jndiname source['jndi_name']
      drivername source['driver']
      connectionurl "jdbc:#{source['driver']}://#{source['server']}:#{source['port']}/#{source['db_name']}"
      username source['db_user']
      password source['db_pass']
      action %i[delete create]
      notifies :restart, 'service[keycloak]', :delayed
    end
  end

  # ----- Email Configuration
  wildfly_attribute 'host-smtp-mail' do
    path '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=mail-smtp'
    parameter 'host'
    value node['wildfly']['smtp']['host'].to_s
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  wildfly_attribute 'port-smtp-mail' do
    path '/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=mail-smtp'
    parameter 'port'
    value node['wildfly']['smtp']['port'].to_i
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  wildfly_attribute 'ssl-smtp-server' do
    path '/subsystem=mail/mail-session=default/server=smtp'
    parameter 'ssl'
    value node['wildfly']['smtp']['ssl']
    action :set
    notifies :restart, 'service[keycloak]', :delayed
    only_if node['wildfly']['smtp']['ssl']
  end
  # if username is not NULL, set username
  if !node['wildfly']['smtp']['username'].nil? && !node['wildfly']['smtp']['username'].empty?
    wildfly_attribute 'username-smtp-server' do
      path '/subsystem=mail/mail-session=default/server=smtp'
      parameter 'username'
      value node['wildfly']['smtp']['username'].to_s
      action :set
      notifies :restart, 'service[keycloak]', :delayed
    end
  end
  # set password if both username and password is NOT NULL
  if !(node['wildfly']['smtp']['username'].nil? || node['wildfly']['smtp']['username'].empty?) && !(node['wildfly']['smtp']['password'].nil? || node['wildfly']['smtp']['password'].empty?)
    wildfly_attribute 'username-smtp-server' do
      path '/subsystem=mail/mail-session=default/server=smtp'
      parameter 'username'
      value node['wildfly']['smtp']['password'].to_s
      action :set
      notifies :restart, 'service[keycloak]', :delayed
    end
  end
  # ----- End Email Configuration

  # ----- Infinispan Configuration
  wildfly_attribute 'realms-max-entry' do
    path '/subsystem=infinispan/cache-container=keycloak/local-cache=realms/component=eviction'
    parameter 'max-entries'
    value node['keycloak']['realms']['max'].to_i
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  wildfly_attribute 'users-max-entry' do
    path '/subsystem=infinispan/cache-container=keycloak/local-cache=users/component=eviction'
    parameter 'max-entries'
    value node['keycloak']['users']['max'].to_i
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  # ----- End Infinispan Configuration

  # ----- Keycloak Server Configuration
  wildfly_attribute 'realms-spi' do
    path '/subsystem=keycloak-server/spi=realmCache/provider=default'
    parameter 'enabled'
    value node['keycloak']['realmcache']['enabled']
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  wildfly_attribute 'users-spi' do
    path '/subsystem=keycloak-server/spi=userCache/provider=default'
    parameter 'enabled'
    value node['keycloak']['usercache']['enabled']
    action :set
    notifies :restart, 'service[keycloak]', :delayed
  end
  # ----- End Keycloak Server Configuration
end

#
# Cookbook Name:: keycloak
# Recipe:: default
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

include_recipe 'java' if node['wildfly']['install_java']
include_recipe 'keycloak::install'

include_recipe 'wildfly::mysql_connector' if node['wildfly']['mysql']['enabled'] == 'true' || node['wildfly']['mysql']['enabled'] == true

if node['wildfly']['postgresql']['enabled'] == 'true' || node['wildfly']['postgresql']['enabled'] == true
  include_recipe 'wildfly::postgres_connector'
  # -ds.xml will be deprecated soon. Inject datasource in the Standalone XML using datasource attributes instead
  # include_recipe 'wildfly::postgres_datasources'
end

include_recipe 'keycloak::h2_datasources' unless node['wildfly']['mysql']['enabled'] == 'true' || node['wildfly']['mysql']['enabled'] == true || node['wildfly']['postgresql']['enabled'] == 'true' || node['wildfly']['postgresql']['enabled'] == true

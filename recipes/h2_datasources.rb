#
# Cookbook Name:: keycloak
# Recipe:: h2_datasources
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

#
# => Check this out for defining datasources...
# => http://www.ironjacamar.org/doc/schema/datasources_1_2.xsd
#

# => Shorten Hashes
wildfly = node['wildfly']
h2 = node['wildfly']['h2']

h2['jndi']['datasources'].each do |source|
  template ::File.join(wildfly['base'], 'standalone', 'deployments', "#{::File.basename(source['jndi_name'])}-ds.xml") do
    source 'h2-ds.xml.erb'
    user wildfly['user']
    group wildfly['group']
    mode '0600'
    variables(
      jndi_name: source['jndi_name'],
      h2_db_name: source['db_name'],
      h2_user: source['db_user'],
      h2_pass: source['db_pass']
    )
    action :create
    notifies :restart, "service[#{wildfly['service']}]", :delayed
  end
end

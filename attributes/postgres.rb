#
# Cookbook Name:: keycloak
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

# => PostgreSQL Database Configuration
# => PostgreSQL driver
default['wildfly']['postgresql']['enabled'] = true
default['wildfly']['postgresql']['url'] = 'http://central.maven.org/maven2/org/postgresql/postgresql/9.4-1206-jdbc41/postgresql-9.4-1206-jdbc41.jar'
default['wildfly']['postgresql']['checksum'] = '45b828279515802c842861cf4abbe36115c493e9e5c82916dade6dd28b84a824'

# => PostgreSQL driver JDBC Module Name
default['wildfly']['postgresql']['mod_name'] = 'org.postgresql'
# => PostgreSQL driver Module Dependencies
default['wildfly']['postgresql']['mod_deps'] = ['javax.api', 'javax.transaction.api']

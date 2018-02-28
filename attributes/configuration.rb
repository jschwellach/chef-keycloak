#
# Cookbook Name:: keycloak
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

# => This cookbook is based on the wildfly cookbook
# => https://github.com/bdwyertech/chef-wildfly
# => we are overwriting the necessary files with the files from the keycloak distribution

default['keycloak']['config']['clients'] = [
  sysprops: [
    source: 'system-properties.cli.erb'
  ],
  datamodule: [
    source: 'datamodule.cli.erb'
  ],
  database: [
    source: 'database.cli.erb'
  ],
  email: [
    source: 'email.cli.erb'
  ],
  interfaces: [
    source: 'interfaces.cli.erb'
  ]
]

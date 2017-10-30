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

# => Wildfly User Configuration

# => Access Control Provider (simple, or rbac)
default['wildfly']['acp'] = 'simple'

# => By default, Wildfly expexts this password hash format:
# => # => username=HEX( MD5( username ':' realm ':' password))

# => Default user - keycloak - s3cr3t
default['wildfly']['users']['mgmt'] = [
  { id: 'keycloak', passhash: 'e3deb717efeff956c5481df359972695' }
]

# Add application users to the hash 'app'  eg.
#
default['wildfly']['users']['app'] = [
  { id: 'keycloak', passhash: 'e3deb717efeff956c5481df359972695' }
]

# Add application roles eg.
#
default['wildfly']['roles']['app'] = [
  # { id: 'wildfly', roles: 'role1,role2' }
]

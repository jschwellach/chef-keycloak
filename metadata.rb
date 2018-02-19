name             'keycloak'
maintainer       'Janos Schwellach'
maintainer_email 'jschwellach@gmail.com'
license 'Apache-2.0'
description      'Installs/Configures keycloak'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.4.3'
chef_version '>= 12.5' if respond_to?(:chef_version)

supports 'centos', '>= 6.2'
supports 'amazon', '>= 2016.09'

depends 'apt'
depends 'yum'
depends 'java', '~> 1.50.0'

# Latest Version of Wildlfy Cookbook ~>1.0.0 makes use of resources
# There is a need to update the keycloak cookbook to use resources too or Use the backward compatibility resources
# to install Keycloak Properly
depends 'wildfly', '~> 0.4.3'

source_url 'https://github.com/jschwellach/chef-keycloak' if respond_to?(:source_url)
issues_url 'https://github.com/jschwellach/chef-keycloak/issues' if respond_to?(:issues_url)

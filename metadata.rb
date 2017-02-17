name             'keycloak'
maintainer       'Janos Schwellach'
maintainer_email 'jschwellach@gmail.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures keycloak'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.5.1-HOTFIX-1'

supports 'centos', '>= 6.2'
supports 'amazon', '>= 2016.09'

depends 'apt'
depends 'yum'
depends 'java', '~> 1.22'
depends 'wildfly', '~> 0.4.0'

source_url 'https://github.com/jschwellach/chef-keycloak' if respond_to?(:source_url)
issues_url 'https://github.com/jschwellach/chef-keycloak/issues' if respond_to?(:issues_url)

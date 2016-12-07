name             'keycloak'
maintainer       'Janos Schwellach'
maintainer_email 'jschwellach@gmail.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures keycloak'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ amazon centos }.each do |os|
  supports os
end

depends 'wildfly', '~> 0.4.2'
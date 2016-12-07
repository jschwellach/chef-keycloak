# => This cookbook is based on the wildfly cookbook 
# => https://github.com/bdwyertech/chef-wildfly
# => we are overwriting the necessary files with the files from the keycloak distribution

# => source is changed to use keycloak instead of wildfly
default['wildfly']['version'] = '2.4.0'
default['wildfly']['url'] = 'https://downloads.jboss.org/keycloak/2.4.0.Final/keycloak-2.4.0.Final.tar.gz'
default['wildfly']['checksum'] = 'c30d8b2d934dd0bd2f7409a3e330ca54ecffc69897b2e1553d35973b72753409'
  
# => base directory  
default['wildfly']['base'] = '/opt/keycloak'
  
# => set user & group
default['wildfly']['user'] = 'keycloak'
default['wildfly']['group'] = 'keycloak'
  
# => set service name
default['wildfly']['service'] = 'keycloak'
  
# => install java
default['wildfly']['install_java'] = true
  
# => Hardcode JAVA_HOME into init.d configuration.
# => Based on value of node['java']['java_home']
default['wildfly']['java']['enforce_java_home'] = true
  
# => enable postgresql
default['wildfly']['postgresql']['enabled'] = false

# => enable mysql
default['wildfly']['mysql']['enabled'] = false
  
# => configure the deployment mode (standalone or domain). 
# => This will affect the configuration files below
default['wildfly']['mode'] = 'standalone'
  
# => this is just for the wildfly recipe and will be overwritten by this cookbook in keycloak::configuration
default['wildfly']['sa']['conf'] = 'standalone.xml'

# => SMTP Settings
default['wildfly']['smtp']['host'] = 'localhost'
default['wildfly']['smtp']['port'] = '25'
default['wildfly']['smtp']['ssl'] = false
default['wildfly']['smtp']['username'] = nil
default['wildfly']['smtp']['password'] = nil
  
# => Interface Configuration
# => Should probably put a proxy in front of these... Maybe NginX?
default['wildfly']['int']['mgmt']['bind'] = '0.0.0.0'
default['wildfly']['int']['mgmt']['http_port'] = '9990'
default['wildfly']['int']['mgmt']['https_port'] = '9993'

default['wildfly']['int']['pub']['bind'] = '0.0.0.0'
default['wildfly']['int']['pub']['http_port'] = '8080'
default['wildfly']['int']['pub']['https_port'] = '8443'

default['wildfly']['int']['wsdl']['bind'] = '0.0.0.0'
default['wildfly']['int']['ajp']['port'] = '8009'

# => Use this to offset all port bindings.  Each binding will be incremented by this value.
default['wildfly']['int']['port_binding_offset'] = '0'
  
# => AWS S3_Ping Configuration
default['wildfly']['aws']['s3_access_key'] = nil
default['wildfly']['aws']['s3_secret_access_key'] = nil
default['wildfly']['aws']['s3_bucket'] = nil;
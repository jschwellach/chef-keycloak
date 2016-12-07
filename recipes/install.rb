# => Shorten Hashes
wildfly = node['wildfly']

include_recipe "wildfly::install"

begin
    r = resources(:template => ::File.join(wildfly['base'], 'standalone', 'configuration', wildfly['sa']['conf']))
    r.cookbook "keycloak"
    r.source "standalone-keycloak.xml.erb"
    r.mode 0755
    r.variables(
      :port_binding_offset => wildfly['int']['port_binding_offset'],
      :mgmt_int => wildfly['int']['mgmt']['bind'],
      :mgmt_http_port => wildfly['int']['mgmt']['http_port'],
      :mgmt_https_port => wildfly['int']['mgmt']['https_port'],
      :pub_int => wildfly['int']['pub']['bind'],
      :pub_http_port => wildfly['int']['pub']['http_port'],
      :pub_https_port => wildfly['int']['pub']['https_port'],
      :wsdl_int => wildfly['int']['wsdl']['bind'],
      :ajp_port => wildfly['int']['ajp']['port'],
      :smtp_host => wildfly['smtp']['host'],
      :smtp_port => wildfly['smtp']['port'],
      :smtp_ssl => wildfly['smtp']['ssl'],
      :smtp_user => wildfly['smtp']['username'],
      :smtp_pass => wildfly['smtp']['password'],
      :acp => wildfly['acp'],
      :s3_access_key => wildfly['aws']['s3_access_key'],
      :s3_secret_access_key => wildfly['aws']['s3_secret_access_key'],
      :s3_bucket => wildfly['aws']['s3_bucket']
    )
    r.notifies :restart, "service[#{wildfly['service']}]", :delayed
    r.only_if { !::File.exist?(::File.join(wildfly['base'], '.chef_deployed')) || wildfly['enforce_config'] }
    rescue Chef::Exceptions::ResourceNotFound
        Chef::Log.warn "could not find template to override!"
end

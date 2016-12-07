default['wildfly']['h2']['jndi']['datasources'] = [
  {
    jndi_name: 'java:jboss/datasources/KeycloakDS',
    db_name: 'keycloak',
    db_user: 'sa',
    db_pass: 'sa'
  }
]

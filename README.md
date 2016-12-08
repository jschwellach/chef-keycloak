# Keycloak Cookbook
Cookbook to deploy Keycloak - Open Source Identity and Access Management
This cookbook is based on the wildlfy cookbook (https://github.com/bdwyertech/chef-wildfly) by Brian Dwyer (https://github.com/bdwyertech)

[![Build Status](https://travis-ci.org/jschwellach/chef-keycloak.svg?branch=master)](https://travis-ci.org/jschwellach/chef-keycloak)

# Requirements
- Chef Client 11+
- Wildfly Cookbook (0.4.2)
- Java Cookbook (ignored if node['wildfly']['install_java'] is false)

# Platform
- CentOS, Red Hat
- Amazon Linux, Amazon

Tested on:
- CentOS 6.7
- Amazon Linux

# Usage
Please refer to the underlying Wildfly cookbook for all parameters. 
This cookbook overwrites the template used in the Wildfly cookbook to use the configuration coming from Keycloak


# Authors
Author:: Janos Schwellach

# == Class: razor
#
# Main class for Razor Provisioning
#
# === Parameters
# * enable_client (boolean): Whether to install/configure Razor Client
# * enable_db (boolean): Whether to configure Postgres DB for Razor
# * enable_server (boolean): Whether to install/configure Razor Server
# * enable_tftp (boolean): Whether to retrieve and "export" bootfiles to PXE Server
# * compile_microkernel (boolean): Whether to create new Microkernel for Razor
# * client_package_name (string): See Params
# * client_package_version (string): Package version for Razor Client (Default: 'latest')
# * database_hostname (string): Hostname for Postgres DB (Default: 'localhost')
# * database_name (string): Database name for Postgres DB (Default: 'razor_prod')
# * database_username (string): Username for Postgres DB (Default: 'razor')
# * database_password (string): Password for Postgres DB. REQUIRED (*)
# * server_package_name (string): See Params
# * server_package_version (string): Package version for Razor Server (Default: 'present')
# * torquebox_package_name (string): See Params
# * torquebox_package_version (string): Package version for Torquebox (Default: 'present')
# * server_config_file (string): See Params
# * server_service_name (string): See Params
# * microkernel_url (string): See Params
# * server_http_port (string): See Params
# * server_https_port (string): See Params
#
# (*) It is highly recommended to put secret keys in Hiera-eyaml and use automatic parameter lookup
# [https://github.com/TomPoulton/hiera-eyaml]
# [https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup]
#
# === Examples
#  class{ 'razor':
#    compile_microkernel   => false,
#    db_hostname           => $::fqdn,
#    db_database           => 'razor',
#    db_user               => 'razor',
#    db_password           => 'notsecret',
#  }
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor (
  # Deployment Options
  $enable_client            = true,
  $enable_db                = true,
  $enable_server            = true,
  $enable_tftp              = true,
  $compile_microkernel      = true,

  # Client
  $client_package_name      = $razor::params::client_package_name,
  $client_package_version   = 'latest',

  # DB
  $database_hostname        = 'localhost',
  $database_name            = 'razor_prod',
  $database_username        = 'razor',
  $database_password        = undef,

  # Server
  $server_package_name        = $razor::params::server_package_name,
  $server_package_version     = 'present',
  $torquebox_package_name     = $razor::params::torquebox_package_name,
  $torquebox_package_version  = 'present',
  $server_config_file         = $razor::params::server_config_file,
  $server_service_name        = $razor::params::server_service_name,
  $server_http_port           = $razor::params::server_http_port,
  $server_https_port          = $razor::params::server_https_port,
  $server_broker_paths          = $razor::params::server_broker_paths,
  $server_task_paths          = $razor::params::server_task_paths,
  $server_hook_paths          = $razor::params::server_hook_paths,

  # TFTP
  $server_hostname          = $::ipaddress,
  $tftp_root                = undef,

  # Microkernel
  $microkernel_url          = $razor::params::microkernel_url,
  $repo_store               = $razor::params::repo_store,
) inherits razor::params {
  # Validation
  validate_bool($enable_client, $enable_db, $enable_server, $compile_microkernel)

  # Dependencies
  anchor { 'razor-server-dependencies': }
  anchor { 'razor-server-postinstall': }

  # Razor Client
  if $enable_client {
    contain razor::client
  }

  # Razor DB
  if $enable_db {
    contain razor::db

    Class['razor::db'] -> Anchor['razor-server-dependencies']
  }

  # Razor Server
  if $enable_server {
    contain razor::server

    Anchor['razor-server-dependencies'] -> Class['razor::server'] -> Anchor['razor-server-postinstall']
  }

  # Razor Microkernel download/unpack
  if $microkernel_url != undef {
    contain razor::microkernel

    Anchor['razor-server-postinstall'] -> Class['razor::microkernel']
  }

  # Razor TFTP Server
  if $enable_tftp {
    contain razor::tftp

    Anchor['razor-server-postinstall'] -> Class['razor::tftp']
  }

  # Razor Microkernel Compiler
  if $compile_microkernel {
    contain razor::microkernel::compile
  }

  # Shiro Authentication is not (yet) implemented. See notes in lib/puppet/provider/razo_rest.rb if you implement it.
}

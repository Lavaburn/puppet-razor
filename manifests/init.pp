# == Class: razor
#
# Main class for Razor Provisioning
#
# === Parameters
# * enable_client (boolean): Whether to install/configure Razor Client (Default: true)
# * enable_db (boolean): Whether to configure Postgres DB for Razor (Default: true)
# * enable_server (boolean): Whether to install/configure Razor Server (Default: true)
# * enable_tftp (boolean): Whether to retrieve and "export" bootfiles to PXE Server (Default: true)
# * compile_microkernel (boolean): See Params
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
# * server_hostname (string): The hostname of the TFTP server. (Default: $::ipaddress)
# * tftp_root (string): The root directory for the TFTP server. (Default: undef)
# * microkernel_url (string): See Params
# * match_nodes_on (array): See Params
# * enable_new_ports_support (boolean): Whether to use the new ports allocated from Razor 1.1.0  (Default: false)
# * enable_aio_support (boolean): Whether to use AIO package paths from Razor 1.4.0  (Default: false)
# * server_http_port (string): HTTP server port name/number - Deprecated, use enable_new_ports_support instead.
# * server_https_port (string): HTTPS server port name/number - Deprecated, use enable_new_ports_support instead.
# * config_dir (path): Path where configuration files are stored  - Deprecated, use enable_aio_support instead.
# * data_dir (path): Path where data (brokers/tasks) are stored - Deprecated, use enable_aio_support instead.
# * repo_store (path): Path where microkernel and OS images are stored - Deprecated, use enable_aio_support instead.
# * binary_dir (path): Path where razor-admin binary is stored - Deprecated, use enable_aio_support instead.
# * jruby_binary_dir (path): Path where jruby binary is stored - Deprecated, use enable_aio_support instead.
# * torquebox_binary_dir (path): Path where torquebox binary are stored - Deprecated, use enable_aio_support instead.
# * install_api_gems (boolean): Whether to setup Ruby gems for using defined types. (Default: true)
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
  Boolean $enable_client       = true,
  Boolean $enable_db           = true,
  Boolean $enable_server       = true,
  Boolean $enable_tftp         = true,
  Boolean $compile_microkernel = $razor::params::compile_microkernel,

  # Client
  String $client_package_name    = $razor::params::client_package_name,
  String $client_package_version = 'latest',

  # DB
  String $database_hostname                 = 'localhost',
  String $database_name                     = 'razor_prod',
  String $database_username                 = 'razor',
  Variant[Undef, String] $database_password = undef,

  # Server
  String $server_package_name       = $razor::params::server_package_name,
  String $server_package_version    = 'present',
  String $torquebox_package_name    = $razor::params::torquebox_package_name,
  String $torquebox_package_version = 'present',
  String $server_config_file        = $razor::params::server_config_file,
  String $server_service_name       = $razor::params::server_service_name,

  # TFTP
  String $server_hostname           = $::ipaddress,
  Variant[Undef, String] $tftp_root = undef,

  # Microkernel
  String $microkernel_url = $razor::params::microkernel_url,

  # Required Configuration
  Array $match_nodes_on = $razor::params::match_nodes_on,

  # Version-specific defaults
  Boolean $enable_new_ports_support = false,
  Boolean $enable_aio_support       = false,

  # Override defaults
  Variant[Undef, Integer] $server_http_port  = undef,
  Variant[Undef, Integer] $server_https_port = undef,

  Variant[Undef, String] $config_dir           = undef,
  Variant[Undef, String] $data_dir             = undef,
  Variant[Undef, String] $repo_store           = undef,
  Variant[Undef, String] $binary_dir           = undef,
  Variant[Undef, String] $jruby_binary_dir     = undef,
  Variant[Undef, String] $torquebox_binary_dir = undef,

  # REST API
  Boolean $install_api_gems = true,
) inherits razor::params {
  # Ports
  if ($enable_new_ports_support) {
    $default_server_http_port  = 8150
    $default_server_https_port = 8151
  } else {
    $default_server_http_port  = 8080
    $default_server_https_port = 8081
  }

  if ($server_http_port == undef) {
    $real_server_http_port = $default_server_http_port
  } else {
    $real_server_http_port = $server_http_port
  }

  if ($server_https_port == undef) {
    $real_server_https_port = $default_server_https_port
  } else {
    $real_server_https_port = $server_https_port
  }

  # Paths
  if ($enable_aio_support) {
    $default_config_dir           = '/etc/puppetlabs/razor-server'
    $default_data_dir             = '/opt/puppetlabs/server/apps/razor-server/share/razor-server'
    $default_repo_store           = '/opt/puppetlabs/server/data/razor-server/repo'
    $default_binary_dir           = '/opt/puppetlabs/bin'
    $default_jruby_binary_dir     = '/opt/puppetlabs/server/apps/razor-server/bin'
    $default_torquebox_binary_dir = '/opt/puppetlabs/server/apps/razor-server/sbin'
  } else {
    $default_config_dir           = '/etc/razor'
    $default_data_dir             = '/opt/razor'
    $default_repo_store           = '/var/lib/razor/repo-store'
    $default_binary_dir           = '/opt/razor/bin'
    $default_jruby_binary_dir     = '/opt/razor-torquebox/jruby/bin'
    $default_torquebox_binary_dir = '/opt/razor-torquebox/jruby/bin'
  }

  if ($config_dir == undef) {
    $real_config_dir = $default_config_dir
  } else {
    $real_config_dir = $config_dir
  }

  if ($data_dir == undef) {
    $data_root_path =  $default_data_dir
  } else {
    $data_root_path =  $data_dir
  }

  if ($repo_store == undef) {
    $repo_store_path = $default_repo_store
  } else {
    $repo_store_path = $repo_store
  }

  if ($binary_dir == undef) {
    $binary_path = $default_binary_dir
  } else {
    $binary_path = $binary_dir
  }

  if ($jruby_binary_dir == undef) {
    $jruby_binary_path = $default_jruby_binary_dir
  } else {
    $jruby_binary_path = $jruby_binary_dir
  }

  if ($torquebox_binary_dir == undef) {
    $torquebox_binary_path = $default_torquebox_binary_dir
  } else {
    $torquebox_binary_path = $torquebox_binary_dir
  }

  $server_config_path = "${real_config_dir}/${server_config_file}"

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

  # Dependency Gems Installation - these are required if you use the defined types
  if ($install_api_gems) {
    if versioncmp($::puppetversion, '4.0.0') < 0 {
      ensure_packages(['rest-client'], {'ensure' => 'present', 'provider' => 'gem'})
    } else {
      ensure_packages(['rest-client'], {'ensure' => 'present', 'provider' => 'puppet_gem'})
    }
  }
}

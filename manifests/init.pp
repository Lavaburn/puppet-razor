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
# * client_package_version (string): Package version for Razor Client (Default: 'present')
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
# * server_auto_deploy (boolean): Whether to migrate database, redeploy torquebox and restart service on changes (Default: true)
# * server_broker_paths (array): See Params
# * server_task_paths (array): See Params
# * server_hook_paths (array): See Params
# * enable_new_ports_support (boolean): Whether to use the new ports allocated from Razor 1.1.0  (Default: false)
# * enable_aio_support (boolean): Whether to use AIO package paths from Razor 1.4.0  (Default: false)
# * match_nodes_on (array): See Params
# * server_hostname (string): The hostname of the Razor API. (Default: $::ipaddress)
# * tftp_root (string): The root directory for the TFTP server. (Default: undef)
# * undionly_kpxe_url (string): See Params
# * microkernel_url (string): See Params. Set undef to disable the download.
# * server_http_port (string): Overwrite the default HTTP server port name/number - Prefer enable_new_ports_support
# * server_https_port (string): Overwrite the default HTTPS server port name/number - Prefer enable_new_ports_support
# * config_dir (path): Path where configuration files are stored  - Deprecated, use enable_aio_support instead.
# * data_dir (path): Path where data (brokers/tasks) are stored - Deprecated, use enable_aio_support instead.
# * repo_store (path): Path where microkernel and OS images are stored - Deprecated, use enable_aio_support instead.
# * binary_dir (path): Path where razor-admin binary is stored - Deprecated, use enable_aio_support instead.
# * jruby_binary_dir (path): Path where jruby binary is stored - Deprecated, use enable_aio_support instead.
# * torquebox_binary_dir (path): Path where torquebox binary are stored - Deprecated, use enable_aio_support instead.
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
  String $client_package_version = 'present',

  # DB
  String $database_hostname           = 'localhost',
  String $database_name               = 'razor_prod',
  String $database_username           = 'razor',
  Optional[String] $database_password = undef,

  # Server
  String $server_package_name       = $razor::params::server_package_name,
  String $server_package_version    = 'present',
  String $torquebox_package_name    = $razor::params::torquebox_package_name,
  String $torquebox_package_version = 'present',

  String $server_config_file  = $razor::params::server_config_file,
  String $server_service_name = $razor::params::server_service_name,

  Boolean $server_auto_deploy = true,

  Array $server_broker_paths = $razor::params::server_broker_paths,
  Array $server_task_paths   = $razor::params::server_task_paths,
  Array $server_hook_paths   = $razor::params::server_hook_paths,

  Boolean $enable_new_ports_support = false,
  Boolean $enable_aio_support       = false,

  Array $match_nodes_on = $razor::params::match_nodes_on,

  # TFTP
  String $server_hostname                   = $::ipaddress,
  Optional[Stdlib::Absolutepath] $tftp_root = undef,
  String $undionly_kpxe_url                 = $razor::params::undionly_kpxe_url,

  # Microkernel
  Optional[String] $microkernel_url = $razor::params::microkernel_url,

  String $mk_install_dir    = $razor::params::mk_install_dir,
  String $mk_install_script = $razor::params::mk_install_script,

  String $mk_repo_source   = $razor::params::mk_repo_source,
  String $mk_repo_revision = $razor::params::mk_repo_revision,

  # Override defaults
  Optional[Integer] $server_http_port  = undef,
  Optional[Integer] $server_https_port = undef,

  Optional[String] $config_dir           = undef,
  Optional[String] $data_dir             = undef,
  Optional[String] $repo_store           = undef,
  Optional[String] $binary_dir           = undef,
  Optional[String] $jruby_binary_dir     = undef,
  Optional[String] $torquebox_binary_dir = undef,
) inherits razor::params {
  ## Additional parameters based on configuration

  # Ports
  if ($server_http_port != undef) {
    $real_server_http_port = $server_http_port
  } elsif ($enable_new_ports_support) {
    $real_server_http_port = 8150
  } else {
    $real_server_http_port = 8080
  }

  if ($server_https_port != undef) {
    $real_server_https_port = $server_https_port
  } elsif ($enable_new_ports_support) {
    $real_server_https_port = 8151
  } else {
    $real_server_https_port = 8081
  }

  # Paths
  if ($config_dir != undef) {
    $real_config_dir = $config_dir
  } elsif ($enable_aio_support) {
    $real_config_dir = '/etc/puppetlabs/razor-server'
  } else {
    $real_config_dir = '/etc/razor'
  }

  if ($data_dir != undef) {
    $data_root_path = $data_dir
  } elsif ($enable_aio_support) {
    $data_root_path = '/opt/puppetlabs/server/apps/razor-server/share/razor-server'
  } else {
    $data_root_path = '/opt/razor'
  }

  if ($repo_store != undef) {
    $repo_store_path = $repo_store
  } elsif ($enable_aio_support) {
    $repo_store_path = '/opt/puppetlabs/server/data/razor-server/repo'
  } else {
    $repo_store_path = '/var/lib/razor/repo-store'
  }

  if ($binary_dir != undef) {
    $binary_path = $binary_dir
  } elsif ($enable_aio_support) {
    $binary_path = '/opt/puppetlabs/bin'
  } else {
    $binary_path = '/opt/razor/bin'
  }

  if ($jruby_binary_dir != undef) {
    $jruby_binary_path = $jruby_binary_dir
  } elsif ($enable_aio_support) {
    $jruby_binary_path = '/opt/puppetlabs/server/apps/razor-server/bin'
  } else {
    $jruby_binary_path = '/opt/razor-torquebox/jruby/bin'
  }

  if ($torquebox_binary_dir != undef) {
    $torquebox_binary_path = $torquebox_binary_dir
  } elsif ($enable_aio_support) {
    $torquebox_binary_path = '/opt/puppetlabs/server/apps/razor-server/sbin'
  } else {
    $torquebox_binary_path = '/opt/razor-torquebox/jruby/bin'
  }

  $server_config_path = "${real_config_dir}/${server_config_file}"


  ## Implementation starts here

  # Dependencies
  anchor { 'razor-server-dependencies': }
  anchor { 'razor-server-installed': }

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

    Anchor['razor-server-dependencies'] -> Class['razor::server'] -> Anchor['razor-server-installed']
  }

  # Razor Microkernel download/unpack
  if $microkernel_url != undef {
    contain razor::microkernel

    Anchor['razor-server-installed'] -> Class['razor::microkernel']
  }

  # Razor TFTP Server
  if $enable_tftp {
    contain razor::tftp

    Anchor['razor-server-installed'] -> Class['razor::tftp']
  }

  # Razor Microkernel Compiler
  if $compile_microkernel {
    contain razor::microkernel::compile
  }
}

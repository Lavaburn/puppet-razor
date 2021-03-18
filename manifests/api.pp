# == Class: razor::api
#
# Class for configuring the API access that is used by Custom Types.
#
# === Parameters
# * http_method (string): Whether to use HTTP or HTTPS. Default: http
# * hostname (string): The hostname on which the Razor Server is located. Default: localhost
# * port (integer): Overwrite the default port if set.
# * client_cert (string): The path to the SSL certificate
# * private_key (string): The path to the SSL private key
# * ca_cert (string): The path to the SSL CA certificate
#
# === Examples
#  class{ 'razor::api': }
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::api (
  Enum['http', 'https'] $http_method = 'http',
  String $hostname                   = 'localhost',
  Optional[Integer] $port            = undef,

  # SSL
  Optional[String] $client_cert = undef,
  Optional[String] $private_key = undef,
  Optional[String] $ca_cert     = undef,

  # Dependencies
  String $rest_client_version   = 'present',
  String $gem_provider          = 'puppet_gem',

  # Paths
  String $config_dir = '/etc/razor',

  # TODO - Shiro Authentication
) {
  # Parameters
  if ($port == undef) {
    if ($::razorserver_version != undef and versioncmp($::razorserver_version, '1.1.0') < 0) {
      $api_port = 8080
    } else {
      $api_port = 8150
    }
  } else {
    $api_port = $port
  }

  # Ensure configuration directory exists
  # TODO: Path is fixed in custom types !!
  ensure_resource('file', [$config_dir], {'ensure' => 'directory'})

  # Configuration File
  file { "${config_dir}/api.yaml":
    ensure  => 'file',
    content => template('razor/api.yaml.erb')
  }

  # Dependencies
  if ($::operatingsystem == 'Ubuntu') {
    ensure_packages(['build-essential', 'g++'], {'ensure' => 'present'})
  }

  # Dependency Gems Installation
  ensure_packages(['rest-client'], {'ensure' => $rest_client_version, 'provider' => $gem_provider})
}

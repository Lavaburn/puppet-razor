# Class: razor::params
#
# Contains system-specific parameters
#
# Parameters:
#   * client_package_name (string): Package name for Razor Client
#   * server_package_name (string): Package name for Razor Server
#   * server_config_file (string): Path to configuration file for Razor Server
#   * server_service_name (string): Name of the service that manages Razor Server
#
class razor::params {
  $client_package_name = 'razor-client'

  $server_package_name = 'razor-server'

  $server_config_file = '/etc/razor/config.yaml'
  $server_service_name = 'razor-server'
}

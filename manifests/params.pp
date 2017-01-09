# Class: razor::params
#
# Contains system-specific parameters
#
# Parameters:
#   * compile_microkernel (boolean): Whether to compile the microkernel (only supported on RedHat)
#   * client_package_name (string): Package name for Razor Client
#   * server_package_name (string): Package name for Razor Server
#   * torquebox_package_name (string): Package name for Torquebox
#   * server_config_file (string): Filename for configuration of Razor Server
#   * server_service_name (string): Name of the service that manages Razor Server
#   * microkernel_url (string): URL of where to download Microkernel (tarball). Set undef to skip.
#   * match_nodes_on (array): unique identifiers for the node (?)
#
class razor::params {
  if ($::operatingsystem =~ 'CentOS') {
    if (versioncmp($::operatingsystemmajrelease, '7') >= 0) {
      $compile_microkernel = true
    } else {
      $compile_microkernel = false
    }
  } else {
    $compile_microkernel = false
  }

  $client_package_name    = 'razor-client'
  $server_package_name    = 'razor-server'
  $torquebox_package_name = 'razor-torquebox'

  $server_config_file  = 'config.yaml'
  $server_service_name = 'razor-server'

  $microkernel_url = 'http://links.puppetlabs.com/razor-microkernel-latest.tar'

  $match_nodes_on = ['mac']
}

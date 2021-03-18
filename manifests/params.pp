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
#   * repo_store (string): Path where microkernel and OS images are stored.
#   * server_http_port (string): HTTP server port name/number
#   * server_https_port (string): HTTPS server port name/number
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

  $server_config_file = '/etc/razor/config.yaml'
  $server_service_name = 'razor-server'

  $microkernel_url = 'http://links.puppetlabs.com/razor-microkernel-latest.tar'
  $repo_store = '/var/lib/razor/repo-store/'
  $server_task_paths = []
  $server_hook_paths = []
  $server_broker_paths = []
  $server_http_port = '8080'
  $server_https_port = '8081'
  $match_nodes_on = ['mac']
}

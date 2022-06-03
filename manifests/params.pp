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
#   * server_broker_paths (array): TODO
#   * server_task_paths (array): TODO
#   * server_hook_paths (array): TODO
#   * match_nodes_on (array): Array of unique identifiers for the node
#   * undionly_kpxe_url (string): The URL where you can download undionly.kpxe
#   * microkernel_url (string): URL of where to download Microkernel (tarball).
#
class razor::params {
  # Operating System specific
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

  $server_task_paths   = []
  $server_hook_paths   = []
  $server_broker_paths = []

  $undionly_kpxe_url   = 'http://boot.ipxe.org/undionly.kpxe'

  $microkernel_url = 'http://links.puppetlabs.com/razor-microkernel-latest.tar'

  $match_nodes_on = ['mac']

  $mk_install_dir     = '/opt/razor-el-mk'
  $mk_install_script  = '/opt/build-microkernel.sh'

  $mk_repo_source   = 'https://github.com/puppetlabs-toy-chest/razor-el-mk'
  $mk_repo_revision = 'master' # Your OS must support Ruby 2.6 !!
}

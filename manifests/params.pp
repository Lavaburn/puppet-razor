# Class: razor::params
#
# Contains system-specific parameters
#
# Parameters:
#   * client_package_name (string): Package name for Razor Client
#   * server_package_name (string): Package name for Razor Server
#   * server_config_file (string): Path to configuration file for Razor Server
#   * server_service_name (string): Name of the service that manages Razor Server
#   * microkernel_url (string): URL of where to download Microkernel (tarball). Set undef to skip.
#   * repo_store (string): Path where microkernel and OS images are stored.
#
class razor::params {
  $client_package_name = 'razor-client'

  $server_package_name = 'razor-server'

  $server_config_file = '/etc/razor/config.yaml'
  $server_service_name = 'razor-server'

  $microkernel_url = 'http://links.puppetlabs.com/razor-microkernel-latest.tar'
  $repo_store = '/var/lib/razor/repo-store/'
}

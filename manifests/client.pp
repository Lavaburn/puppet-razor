# == Class: razor::client
#
# Razor Provisioning: Client Setup
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::client inherits razor {
  # TODO: razor client should follow ruby version (based on puppet version)

  # Follow Server version
  if ($::razor::client_package_version == undef) {
    #if (versioncmp($::razor::server_package_version, '1.6.1') <= 0) {
      $real_client_package_version = '1.3.0'
    #} else {
    #  $real_client_package_version = $::razor::server_package_version
    #}
  } else {
    $real_client_package_version = $::razor::client_package_version
  }

  # Install the ruby gem
  ensure_packages([$::razor::client_package_name], {'ensure' => $real_client_package_version, 'provider' => 'puppet_gem'})
}

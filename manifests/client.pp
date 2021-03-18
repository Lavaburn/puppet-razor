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
  # Install the ruby gem
  # The version could depend on both your puppet agent version (ruby env) and razor server version!
  ensure_packages([$::razor::client_package_name], {'ensure' => $::razor::client_package_version, 'provider' => 'puppet_gem'})
}

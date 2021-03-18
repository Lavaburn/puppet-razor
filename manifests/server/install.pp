# == Class: razor::server::install
#
# Razor Provisioning: Server Setup - Installation
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::server::install inherits razor {
  anchor { 'razor-server-preinstall': }
  anchor { 'razor-server-postinstall': }

  if ($::razor::enable_aio_support == false) {
    # Torquebox was auto-dependency < 1.0.0, but no longer by 1.3.0
    # From 1.4.0 (AIO packaging), it is included in the server package.
    Anchor['razor-server-preinstall'] ->
    package { $::razor::torquebox_package_name:
      ensure => $::razor::torquebox_package_version,
    } -> Package[$::razor::server_package_name]
  }

  Anchor['razor-server-preinstall'] ->
  package { $::razor::server_package_name:
    ensure => $::razor::server_package_version,
  } ->
  Anchor['razor-server-postinstall']
}

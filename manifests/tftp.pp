# == Class: razor::tftp
#
# Razor Provisioning: Bootfiles for "exporting" by TFTP Server
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::tftp inherits razor {
  #Root directory
  if ($::razor::tftp_root == undef) {
    $directory = $::tftp::directory
  } else {
    $directory = $::razor::tftp_root
  }

  # undionly.kpxe
  wget::fetch { $::razor::undionly_kpxe_url:
    destination => "${directory}/undionly.kpxe",
  } ->

  tftp::file { 'undionly.kpxe':
    ensure => file,
    source => "${directory}/undionly.kpxe",
  }

  # bootstrap.ipxe
  # TODO: Add support for HTTPS ?
  wget::fetch { "http://${::razor::server_hostname}:${::razor::real_server_http_port}/api/microkernel/bootstrap":
    destination => "${directory}/bootstrap.ipxe",
  } ->

  tftp::file { 'bootstrap.ipxe':
    ensure => file,
    source => "${directory}/bootstrap.ipxe",
  }
}

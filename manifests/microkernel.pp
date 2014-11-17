# == Class: razor::microkernel
#
# Razor Provisioning: Razor microkernel download and unpack
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::microkernel inherits razor {
  # Validation
  validate_string($::razor::microkernel_url)

  include archive::prerequisites

  archive { 'razor-microkernel':
    ensure            => present,
    url               => $::razor::microkernel_url,
    target            => '/var/lib/razor/repo-store/', # TODO PARAM ???
    extension         => 'tar',
  }
}

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
  validate_absolute_path($::razor::repo_store_path)

  include ::archive

  archive { '/tmp/razor-microkernel.tar':
    ensure          => 'present',
    source          => $::razor::microkernel_url,
    extract         => true,
    extract_path    => $::razor::repo_store_path,
    checksum_verify => false,
    creates         => "${::razor::repo_store_path}/microkernel",
    cleanup         => true,
    # archive no longer supports a timeout value. Note that the microkernel is about 160 MB.
  }
}

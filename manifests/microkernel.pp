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
  validate_absolute_path($::razor::repo_store)

  include archive::prerequisites

  archive { 'razor-microkernel':
    url               => $::razor::microkernel_url,
    target            => $::razor::repo_store,
    extension         => 'tar',
    timeout           => 3600, # 160 MB @ 384 kbps
    checksum          => false,
  }

  if $::razor::repo_store == $razor::params::repo_store {
    # Archive will automatically create a folder before extracting !!!
    # Because the tarball includes a root directory (microkernel) a dual folder can not be avoided.
    # Result = $::razor::repo_store/razor-microkernel/microkernel

    file { "${::razor::repo_store}/microkernel":
      ensure  => link,
      target  => "${::razor::repo_store}/razor-microkernel/microkernel",
    }
  }
}

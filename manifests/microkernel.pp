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
    url       => $::razor::microkernel_url,
    target    => $::razor::repo_store,
    # Required !
    extension => 'tar',
    # I don't want to create a subdirectory. Extract contents of tar direct to repo_store
    # Tarball contains root dir called microkernel.
    root_dir  => '.',
    # 160 MB @ 384 kbps
    timeout   => 3600,
    checksum  => false,
  }
}

# == Class: razor::microkernel::compile
#
# Razor Provisioning: Microkernel Compilation
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::microkernel::compile inherits razor {
  # Parameters
  $microkernel_dir = $::razor::mk_install_dir
  $install_script  = $::razor::mk_install_script
  $source          = $::razor::mk_repo_source
  $revision        = $::razor::mk_repo_revision

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'CentOS', 'Fedora': {
          if (versioncmp($::operatingsystemmajrelease, '7') < 0) {
            fail("CentOS ${::operatingsystemmajrelease} is no longer supported by this module! [Last tested on CentOS 7.9]")
          }

          # Ordering
          anchor { 'razor-microkernel-dependencies-repos': }
          anchor { 'razor-microkernel-packages': }
          anchor { 'razor-microkernel-dependencies': }

          # Dependencies
          Anchor['razor-microkernel-dependencies-repos']
          ->
          package { ['git', 'livecd-tools', 'gcc']:
            ensure => 'installed',
          } -> Anchor['razor-microkernel-packages']

          # Download git repository
          Anchor['razor-microkernel-packages']
          ->
          vcsrepo { $microkernel_dir:
            ensure   => 'present',
            provider => 'git',
            source   => $source,
            revision => $revision,
          } -> Anchor['razor-microkernel-dependencies']

          # Create installation script
          file { $install_script:
            ensure  => 'file',
            content => template('razor/build-microkernel.sh.erb'),
            mode    => '0700',
          } -> Anchor['razor-microkernel-dependencies']

          # Run script
          Anchor['razor-microkernel-dependencies']
          ->
          exec { 'build-microkernel':
            cwd     => $microkernel_dir,
            command => $install_script,
            timeout => 3600,
            creates => "${microkernel_dir}/pkg/microkernel.tar"
          }
        }
        default: {
          fail("Operating System (RedHat) is not supported: ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Operating System Family is not supported: ${::osfamily}")
    }
  }
}

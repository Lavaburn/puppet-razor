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
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'CentOS', 'Fedora': {
          # Ordering
          anchor { 'razor-microkernel-dependencies-repos': }
          anchor { 'razor-microkernel-packages': }
          anchor { 'razor-microkernel-dependencies': }

          # Parameters
          $microkernel_dir = '/opt/razor-el-mk'
          $install_script  = '/opt/build-microkernel.sh'
          $source   = 'https://github.com/puppetlabs/razor-el-mk'
          $revision = 'master' # Last known working tag on CentOS 7.2: release-006

          # Dependencies
          Anchor['razor-microkernel-dependencies-repos']
          ->
          package { ['git', 'livecd-tools']:
            ensure => 'installed',
          } -> Anchor['razor-microkernel-packages']

          if (versioncmp($::operatingsystemmajrelease, '7') < 0) {
            warning('CentOS 6.x is no longer supported by this module for microkernel compilation. It is recommended to use CentOS 7.x.')

            # livecd-tools package is not available on CentOS 6 - use EPEL repo
            yumrepo { 'epel':
              baseurl  => "http://download.fedoraproject.org/pub/epel/${::operatingsystemmajrelease}/\$basearch",
              enabled  => 1,
              gpgcheck => 0,
            }
            ->
            Anchor['razor-microkernel-dependencies-repos']

            # Upgrade Ruby 1.8.7 to 1.9.3
            $ruby_version = '1.9.3'
            $rvm_install_script = "/opt/rvm-install-ruby-${ruby_version}.sh"

            file { $rvm_install_script:
              ensure  => 'file',
              content => template('razor/install_rvm.sh.erb'),
              mode    => '0700',
            }
            ~>
            exec { "rvm-install-ruby-${ruby_version}":
              cwd         => '/opt',
              command     => $rvm_install_script,
              refreshonly => true,
              timeout     => 3600,
            }
            ->
            Anchor['razor-microkernel-dependencies']

            # Install realpath command
            package { 'realpath':
              source   => "https://repoforge.cu.be/redhat/el${::operatingsystemmajrelease}/en/x86_64/rpmforge/RPMS/realpath-1.17-1.el${::operatingsystemmajrelease}.rf.x86_64.rpm",
              provider => 'rpm',
            }
            ->
            Anchor['razor-microkernel-dependencies']

            $rvm_enable = "source /etc/profile.d/rvm.sh; /usr/local/rvm/bin/rvm use ${ruby_version}"
            $build_command = "/bin/bash -c '${rvm_enable}; /opt/build-microkernel.sh'"
          } else {
            # Tested on CentOS 7.2
            $build_command = '/opt/build-microkernel.sh'
          }

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
            command => $build_command,
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

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
    'redhat': {
      case $::operatingsystem {
        'CentOS', 'Fedora': {
          # [CentOS] Require EPEL Repository for the livecd-tools
          #$install_epel = true
          $version = $::operatingsystemmajrelease

          # [CentOS 6] Require Ruby 1.9.3
          $extra_packages = ['ruby193']

          # [CentOS 6.5] Require realpath
          $install_realpath = true
          # TODO - check CentOS 5, 7, Fedora 19, 20, RHEL 5, 6, 7 ?

          # Action Chain
          file { '/etc/yum.repos.d/epel.repo':
            content => template('razor/epel.repo.erb'),
          } ->

          package { ['livecd-tools', 'git', 'centos-release-SCL', 'coreutils']:
            ensure => 'installed',
          } ->

          package { $extra_packages:
            ensure => 'installed',
          } ->

          # Download git repository
          vcsrepo { '/opt/razor-el-mk':
            ensure   => present,
            provider => git,
            source   => 'https://github.com/puppetlabs/razor-el-mk',
          } ->

          # Create installation script
          file { '/opt/build-microkernel.sh':
            ensure  => 'file',
            content => template('razor/build-microkernel.sh.erb'),
            mode    => '0700',
          } ->

          # Run script
          exec { 'build-microkernel':
            cwd         => '/opt/razor-el-mk',
            command     => '/usr/bin/scl enable ruby193 /opt/build-microkernel.sh',
            subscribe   => File['/opt/build-microkernel.sh'],
            refreshonly => true,
            timeout     => 3600,
            #creates     => "/opt/razor-el-mk/pkg/microkernel-005.tar"
          }
        }
        default: {
          fail("Operating System (redhat) is not supported: ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Operating System Family is not supported: ${::osfamily}")
    }
  }
}

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
          $version = $::operatingsystemmajrelease

          file { '/etc/yum.repos.d/epel.repo':
            content => template('razor/epel.repo.erb'),
          } ->

          package { ['livecd-tools', 'git', 'centos-release-SCL', 'coreutils']:
            ensure => 'installed',
          } ->

          # [CentOS 6] Require Ruby 1.9.3
          package { ['ruby193']:
            ensure => 'installed',
          } ->

          # Download git repository
          vcsrepo { '/opt/razor-el-mk':
            ensure   => present,
            provider => git,
            source   => 'https://github.com/puppetlabs/razor-el-mk',
          } ->

          # TODO template contains a bug specific to CentOS 6.5
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
				  }

				  # TODO PUBLISH SCRIPT TO WEBSERVER !!!
			    # cd /opt/razor-el-mk/pkg/
			    # scp microkernel-005.tar 192.168.50.13:.     => Replace with Webserver !!

			    # Option B - Pre-compiled MK
			    # wget http://links.puppetlabs.com/razor-microkernel-latest.tar
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

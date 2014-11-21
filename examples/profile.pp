# Class: example::profile
#
# This is an example of how your profile could look when using the razor module
# Don't copy this example blindly.
#
# (*) It is highly recommended to put secret keys in Hiera-eyaml and use automatic parameter lookup
# [https://github.com/TomPoulton/hiera-eyaml]
# [https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup]
#
class example::profile {
  # Dependencies
    # if enable_db => true
    class { '::postgresql::server': }

    # if enable_server => true
      # Debian:
      apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main',
        key        => '1054B7A24BD6EC30',
        key_server => 'pgp.mit.edu',
      }
      # Redhat:
      file { '/etc/yum.repos.d/puppetlabs.repo':
        content => template('razor/puppetlabs.repo.erb')
      }
      #templates/puppetlabs.repo.erb:
        #[puppetlabs]
        #name=Puppetlabs - Official Repo
        #baseurl=http://yum.puppetlabs.com/el/6/products/x86_64/
        #enabled=1
        #gpgcheck=0

    # if enable_tftp => true
    class { '::tftp':
      directory => '/var/lib/tftpboot',
      address   => 'localhost',
    }
    include 'wget'

  # Razor Configuration - Precompiled Microkernel
  class { 'razor':
    db_hostname         => '127.0.0.1',
    db_password         => 'notasecretpassword',
    compile_microkernel => false,
  }

  # Razor Configuration - Compile my own microkernel
  # Below will only work on RHEL/CentOS/Fedora
  # but you can split it up in 2 or more processes.
  class { 'razor':
    db_hostname     => '127.0.0.1',
    db_password     => 'notasecretpassword',
    microkernel_url => 'http://myrazorserver:8010/microkernel-005.tar',
  }

  # To allow the above URL to work, add the below code.
  # This part uses puppetlabs/apache module
  class { 'apache':  }

  apache::vhost { 'myrazorserver':
    port    => '8010',
    docroot => '/opt/razor-el-mk/pkg/',
  }
  Apache::Vhost['myrazorserver'] -> Class['razor']

  # Class Dependencies/Sequence
  Class['postgresql::server'] -> Class['razor']

  # To configure Razor (through the API):
    # See test/types.pp
}

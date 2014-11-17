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
    #TODO PUPPETLABS REPO (APT)
    # Redhat:
    #TODO PUPPETLABS REPO (YUM)

    # if enable_tftp => true
    class { '::tftp':
	    directory => '/var/lib/tftpboot',
	    address   => 'localhost',
	  }
	  include 'wget'

  # Razor Configuration
  class { 'razor':
    db_hostname => '127.0.0.1',
    db_password => 'notasecretpassword',
  }

  # Class Dependencies/Sequence
  Class['postgresql::server'] -> Class['razor']
}

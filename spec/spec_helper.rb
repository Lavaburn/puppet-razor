require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
RSpec.configure do |c|
  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
  
  c.before do
    # avoid "Only root can execute commands as other users"
    # required by Postgres dependency
    Puppet.features.stubs(:root? => true)
    
    @centos = {
      :osfamily                    => 'RedHat',
      :operatingsystem             => 'CentOS',
      :operatingsystemrelease      => '6.6',
      :lsbmajdistrelease           => '6',
      :operatingsystemmajrelease   => '6',
      :path                        => "/usr/local/bin:/opt/puppetlabs/bin",
      :concat_basedir              => '/tmp',
      :clientcert                  => 'centos', # HIERA !!!      
      :ipaddress                   => '192.168.1.1',
      :puppetversion               => '4.0.0',
      :id                          => 'newfact1',
      :kernel                      => 'Linux',
    }
 
    @ubuntu = {
      :osfamily                 => 'Debian',
      :operatingsystem          => 'Ubuntu',
      :lsbdistid                => 'Ubuntu',
      :lsbmajdistrelease        => '12.04',
      :lsbdistcodename          => 'precise',
      :operatingsystemrelease   => '12.04',
      :path                     => "/usr/local/bin:/opt/puppetlabs/bin",
      :concat_basedir           => '/tmp',
      :ipaddress                => '192.168.1.1',
      :puppetversion            => '4.0.0',
      :id                       => 'newfact1',
      :kernel                   => 'Linux',
    }
    
    @dependencies = "
      class { '::postgresql::server': }  
      class { '::tftp':
        directory => '/var/lib/tftpboot',
        address   => 'localhost',
      }
    "
    @razor_default = "
      class { '::razor': 
        enable_tftp => false,
      }
    "
    @razor_default_aio = "
      class { '::razor': 
        enable_tftp              => false,
        enable_new_ports_support => true,
        enable_aio_support       => true,    
      }
    "
  end
end
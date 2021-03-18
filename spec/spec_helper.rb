# Gem includes
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'rspec-puppet-utils'
#require 'rspec/stackprof'

# Paths
proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
  
# Debugging
#RSpec::StackProf.configure do |config|
#  config.out_dir = 'tmp/'
#  config.mode = :cpu 
#  config.interval = 1000
#  config.raw = true
#end
  
# Facts
include RspecPuppetFacts

# Set up before any test
RSpec.configure do |c|
  c.hiera_config = File.join(fixtures_dir, 'hiera/hiera.yaml')
  
  c.before do
    # Bugfix for PostgreSQL ("Only root can execute commands as other users")
    Puppet.features.stubs(:root? => true)
  end
  
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end

# Custom Facts (Puppet Modules)
#add_custom_fact :collectd_version, '5.4.0.git'

def dependencies
  "
  class { '::postgresql::server': }  
  class { '::tftp':
    directory => '/var/lib/tftpboot',
    address   => 'localhost',
  }
"
end

def razor_default 
  "
  class { '::razor': 
    enable_tftp => false,
  }
"
end

def razor_default_aio
  "
  class { '::razor': 
    enable_tftp              => false,
    enable_new_ports_support => true,
    enable_aio_support       => true,    
  }
"
end

require 'beaker-rspec'
require 'support/idempotent_manifest'
require 'support/razor_server_running'
require 'support/valid_mk_image'

RSpec.configure do |c|
	# Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
  
	# Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    # Configure all nodes in nodeset
    agents.each do |agent|
      # Install this module
      install_dev_puppet_module_on(agent, :source => proj_root, :module_name => 'razor', :target_module_path => '/etc/puppetlabs/code/environments/production/modules')
          
      unless ENV['BEAKER_provision'] == 'no'  
        # Platform-specific bugfixes/dependencies
        if fact_on(agent, 'operatingsystem') =~ /Ubuntu/  
          on agent, 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys --recv-keys 7F438280EF8D349F'
          on agent, 'apt-get update'
          
          if fact_on(agent, 'operatingsystemrelease') =~ /14.04/   
            on agent, 'apt-get -y install build-essential ruby'
          end
        end        
        if fact_on(agent, 'osfamily') =~ /RedHat/
          on agent, 'yum install -y gcc-c++ rubygems'
          
          on agent, puppet('module','install','stahnma/epel'),        { :acceptable_exit_codes => [0,1] }
        end
        
        # Puppet Modules (Dependencies)
        on agent, puppet('module','install','reidmv/yamlfile'),       { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppetlabs/postgresql'), { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppetlabs/vcsrepo'),    { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppetlabs/tftp'),       { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppet/archive'),        { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','maestrodev/wget'),       { :acceptable_exit_codes => [0,1] }
          
        install_hiera_on(agent, fixtures_dir)
      end
    end
  end
end

def install_hiera_on(host, fixtures_dir)
  files = [ 'hiera.yaml', 'hiera' ]
  files.each do |file|
    scp_to host, File.expand_path(File.join(fixtures_dir, file)), "/etc/puppetlabs/code/#{file}"
  end
end

def setup_repository(repository)
  if (repository == 'puppetlabs3')
    pl3_ensure = 'present'
    pc1_ensure = 'absent'
    pl3_enabled = 1
    pc1_enabled = 0
  elsif (repository == 'pc1')
    pl3_ensure = 'absent'
    pc1_ensure = 'present'  
    pl3_enabled = 0
    pc1_enabled = 1
  else
    raise "Repository #{repository} is not a valid option."
  end
    
  pp = <<-EOS
    if ($::osfamily == 'Debian') { 
      include ::apt
     
      apt::source { 'puppetlabs3':
        ensure   => '#{pl3_ensure}',          
        location => 'http://apt.puppetlabs.com',
        repos    => 'main',
        key      => {
          'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
          'server' => 'pgp.mit.edu',
        },
      } ~> Exec['apt_update']
    
      apt::source { 'puppetlabs-pc1':
        ensure   => '#{pc1_ensure}',       
        location => 'http://apt.puppetlabs.com',
        repos    => 'PC1',
        key      => {
          'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
          'server' => 'pgp.mit.edu',
        },
      } ~> Exec['apt_update']
    }      
    if ($::osfamily == 'RedHat') { 
      yumrepo { 'puppetlabs3':
        baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/products/${::architecture}",
        enabled  => #{pl3_enabled},
        gpgcheck => 0,
      }

      yumrepo { 'puppetlabs-pc1':
        baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/PC1/${::architecture}",
        enabled  => #{pc1_enabled},
        gpgcheck => 0,
      }
    }
  EOS
  
  agents.each do |agent|
    apply_manifest_on(agent, pp, :catch_failures => true)
  end  
end
      
def get_default_razor_manifest(version, repository, new_ports, aio) 
  get_razor_manifest(version, repository, new_ports, aio, false)
end
      
def get_compilation_manifest(version, repository, new_ports, aio)
  get_razor_manifest(version, repository, new_ports, aio, true)  
end

def get_razor_manifest(version, repository, new_ports, aio, compilation)  
  if (repository == 'puppetlabs3')
    debian = "#{version}-1puppet1"
    redhat = "#{version}-1.el${::operatingsystemmajrelease}"
  elsif (repository == 'pc1')
    debian = "#{version}-1${::lsbdistcodename}"
    redhat = "#{version}-1.el${::operatingsystemmajrelease}"
  else
    raise "Repository #{repository} is not a valid option."
  end
  
  pp = <<-EOS
    $compilation = #{compilation}
  
    if ($::osfamily == 'Debian') { 
      class { '::razor':
        server_package_version   => "#{debian}",
        enable_new_ports_support => #{new_ports},
        enable_aio_support       => #{aio},
      }
    }      
    if ($::osfamily == 'RedHat') { 
      if ($compilation) {      
        class { '::razor':
          server_package_version   => "#{redhat}",
          enable_new_ports_support => #{new_ports},
          enable_aio_support       => #{aio},
        }            
      } else {        
        class { '::razor':
          server_package_version   => "#{redhat}",
          enable_new_ports_support => #{new_ports},
          enable_aio_support       => #{aio},
          compile_microkernel      => false,
        }    
      }
    }
  EOS
  
  pp
end


def build_manifest(*parts)
  manifest = parts.join(" \n")
  manifest
end

def dependencies()
  pp = <<-EOS
    # CentOS 6.x default is PostgreSQL 8.4 and Razor requires >= 9.1
    if ($::operatingsystemmajrelease =~ '6') {
      class { 'postgresql::globals':
        version             => '9.2',
        manage_package_repo => true,
      } -> Class['::postgresql::server']
    }
  
    class { '::postgresql::server': }
    
    class { '::tftp':
      directory => '/var/lib/tftpboot',
      address   => 'localhost',
    }
  EOS
  
  pp
end

def extra_resources()
  pp = <<-EOS
    razor::broker { 'puppet-xenserver': }
    razor::task { 'xenserver': }
  EOS
  
  pp
end
      
def apply_manifests(hosts, manifest, options) 
  result = nil
  
  hosts.each do |host| 
    res = apply_manifest_on(host, manifest, options)
    if result.nil? or res.exit_code > result.exit_code
      result = res
    end
  end
  
  return result
end

def stop_razor()
  pp = <<-EOS
    service { 'razor-server':
      ensure => 'stopped',
    }
  EOS
  
  agents.each do |agent|
    apply_manifest_on(agent, pp, :catch_failures => true)
  end  
end

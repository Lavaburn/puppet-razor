require 'beaker-rspec'

def install_hiera_on(host, fixtures_dir)
  files = [ 'hiera.yaml', 'hiera' ]
  files.each do |file|
    scp_to host, File.expand_path(File.join(fixtures_dir, file)), "/etc/puppetlabs/code/#{file}"
  end
end

RSpec.configure do |c|
	# Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
  
	# Readable test descriptions
  c.formatter = :documentation

	# Configure all nodes in nodeset
  c.before :suite do    
    # Install this module
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => proj_root, :module_name => 'razor', :target_module_path => '/etc/puppetlabs/code/environments/production/modules')
    end
      
    unless ENV['BEAKER_provision'] == 'no'  
      # Install dependencies
      hosts.each do |host|
        on host, 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys --recv-keys 7F438280EF8D349F'
        on host, 'apt-get update'
        
        on host, puppet('module','install','reidmv/yamlfile'),       { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','puppetlabs/postgresql'), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','puppetlabs/vcsrepo'),    { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','puppetlabs/tftp'),       { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','puppet/archive'),        { :acceptable_exit_codes => [0,1] }
        on host, puppet('module','install','maestrodev/wget'),       { :acceptable_exit_codes => [0,1] }
#       if fact_on('osfamily') == 'RedHat'
#          on host, puppet('module','install','stahnma/epel'), { :acceptable_exit_codes => [0,1] }
#       end
          
        install_hiera_on(host, fixtures_dir)
      end      
    end
  end
end

def enable_puppetlabs3() 
  hosts.each do |host|
    apt_manifest = <<-EOS
      apt::source { 'puppetlabs3':
        ensure   => 'present',          
        location => 'http://apt.puppetlabs.com',
        repos    => 'main',
        key      => {
          'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
          'server' => 'pgp.mit.edu',
        },
      }

      apt::source { 'puppetlabs-pc1':
        ensure   => 'absent',
      }        
    EOS
    
    apply_manifest_on(host, apt_manifest, :catch_failures => true)
  end
end

def enable_puppetlabs_pc1() 
  hosts.each do |host|
    apt_manifest = <<-EOS
      apt::source { 'puppetlabs3':
        ensure   => 'absent',
      }

      apt::source { 'puppetlabs-pc1':
        ensure   => 'present',       
        location => 'http://apt.puppetlabs.com',
        repos    => 'PC1',
        key      => {
          'id'     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
          'server' => 'pgp.mit.edu',
        },
      }        
    EOS
    
    apply_manifest_on(host, apt_manifest, :catch_failures => true)
  end
end
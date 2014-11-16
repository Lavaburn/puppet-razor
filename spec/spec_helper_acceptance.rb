require 'spec_helper_rcs'

hosts.each do |host|
  # Using box with pre-installed Puppet !
end

RSpec.configure do |c|
	# Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
  
	# Readable test descriptions
  c.formatter = :documentation

	# Configure all nodes in nodeset
  c.before :suite do  	  
    # Install myself on every host
    puppet_module_install(:source => proj_root, :module_name => 'razor')

    # Install dependencies on every host
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-postgresql'), { :acceptable_exit_codes => [0,1] } 
      on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-vcsrepo'), { :acceptable_exit_codes => [0,1] }
        
      install_hiera_on(host, fixtures_dir)
  
#       if fact_on('osfamily') == 'RedHat'
#          on host, puppet('module','install','stahnma/epel'), { :acceptable_exit_codes => [0,1] }
#       end
    end    
  end
end

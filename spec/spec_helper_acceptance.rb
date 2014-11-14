require 'beaker-rspec'
require 'beaker/librarian'
require 'pry'

hosts.each do |host|
  # Using box with pre-installed Puppet !
end

RSpec.configure do |c|
	# Project root
    proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

	# Readable test descriptions
  	c.formatter = :documentation

	# Configure all nodes in nodeset
  	c.before :suite do		
		# Broken on Ubuntu 14.04 !!! (rubygems => ruby)
			# install_librarian       
			
		hosts.each do |host|
			# Librarian Puppet
			install_package host, 'ruby1.9.1-dev'
			install_package host, 'ruby'
			install_package host, 'git'
			on host, 'gem install librarian-puppet'
    	end
			
		# Hiera
		#  files = [ 'hiera.yaml', 'hiera' ]
		#  files.each do |file|
		#    scp_to master, File.expand_path(File.join(File.dirname(__FILE__), '../spec/fixtures', file)), "/etc/puppet/#{file}"
		#  end
    	
    	# Librarian Puppet
    	librarian_install_modules(proj_root, 'THIS_MODULE')
    	
		# Install modules
		puppet_module_install(:source => proj_root, :module_name => 'THIS_MODULE')
  end
end




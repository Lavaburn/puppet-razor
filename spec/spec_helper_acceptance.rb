# Gem includes
require 'beaker-rspec'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

require 'beaker-puppet'

require 'beaker'
require 'beaker/puppet_install_helper'

require 'infrataster/rspec'

# Helpers
require 'support/acceptance_functions'

# Shared Examples
require 'support/idempotent_manifest'
require 'support/razor_server_running'
require 'support/valid_mk_image'

# Paths
proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
fixtures_dir = File.expand_path(File.join(proj_root, '/spec/fixtures'))
module_path = '/etc/puppetlabs/code/environments/production/modules'

agents.each do |agent|
  on agent, 'export PATH=$PATH:/opt/puppetlabs/bin' 
  on agent, 'echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/puppetlabs/bin" > ~/.ssh/environment'  
end

# Set up before any test
RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do    
    unless ENV['BEAKER_provision'] == 'no'
      # Fixes for installing puppet
      agents.each do |agent|
        next unless fact_on(agent, 'operatingsystem') =~ /CentOS/
        
        on agent, 'curl --remote-name --location https://yum.puppetlabs.com/RPM-GPG-KEY-puppet'
        on agent, 'gpg --keyid-format 0xLONG --with-fingerprint ./RPM-GPG-KEY-puppet'
        on agent, 'rpm --import RPM-GPG-KEY-puppet'        
      end

      # Install correct version of puppet.
      run_puppet_install_helper_on(agents, 'agent', '1.8.3')
    end
    
    # Configure all nodes in nodeset
    agents.each do |agent|
      # Only setup dependencies on provisioning
      unless ENV['BEAKER_provision'] == 'no'
        # Platform-specific bugfixes/dependencies
        if fact_on(agent, 'operatingsystem') =~ /Ubuntu/  
          on agent, 'rm /etc/apt/sources.list.d/puppetlabs-pc1.list'
          on agent, 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys --recv-keys 7F438280EF8D349F'
          on agent, 'apt-get update'
          on agent, 'apt-get -y install git'
          on agent, 'apt-get -y install software-properties-common python-software-properties'
          
#          if fact_on(agent, 'operatingsystemrelease') =~ /14.04/   
#            on agent, 'apt-get -y install build-essential ruby'
#          end
        end 

        if fact_on(agent, 'operatingsystem') =~ /CentOS/  
          on agent, 'yum -y install git'
          on agent, 'yum install -y gcc-c++ rubygems'
          
          on agent, puppet('module','install','stahnma/epel'),        { :acceptable_exit_codes => [0,1] }
        end

        # Setup puppet module dependencies
        on agent, puppet('module','install','puppet/wget'),           { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppet/archive'),        { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppetlabs/postgresql'), { :acceptable_exit_codes => [0,1] }
        on agent, puppet('module','install','puppetlabs/tftp'),       { :acceptable_exit_codes => [0,1] }          
        on agent, puppet('module','install','puppetlabs/vcsrepo'),    { :acceptable_exit_codes => [0,1] }          
        on agent, puppet('module','install','reidmv/yamlfile'),       { :acceptable_exit_codes => [0,1] }
      end
      
      # Always copy this module
      install_dev_puppet_module_on(agent, :source => "#{proj_root}", :module_name => 'razor', :target_module_path => module_path)

      # Always copy hieradata
      install_hiera_on(agent, fixtures_dir)      
    end
  end
end

# Infrataster
agents.each do |agent|
  Infrataster::Server.define(:testhost) do |server|
    server.address = agent[:ip]
    server.ssh = agent[:ssh].tap { |s| s.delete :forward_agent }
  end
end

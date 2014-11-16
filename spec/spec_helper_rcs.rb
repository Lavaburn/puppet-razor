require 'beaker-rspec'
#require 'beaker/librarian'
#require 'pry'

module Beaker
  module Rcs
    include Beaker::DSL
    
    def install_r10k_on(host, opts = {})            
      # CentOS 6.5       
      on host, 'gem install r10k'

      # Ubuntu 12.04
      install_package host, 'rubygems'         
      on host, 'gem install r10k'
     
      # Ubuntu 14.04
      # TODO
    end
    
    def install_librarian_on(host, opts = {})   
      # CentOS 6.5
      # TODO NO SUPPORT BUILT IN FOR 1.9.3
      # install_package host, 'ruby-devel' 
      # on host, 'gem install librarian-puppet'

      # Ubuntu 12.04
      install_package host, 'ruby1.9.1-dev' 
      install_package host, 'rubygems1.9.1' 
      on host, 'gem1.9.1 install librarian-puppet'
              
      # Ubuntu 14.04
      # TODO
    end
        
    def librarian_install_modules_on(host, directory, module_name)
      sut_dir = File.join('/tmp', module_name)
      scp_to host, directory, sut_dir
      on host, "cd #{sut_dir} && librarian-puppet install --clean --verbose --path #{host['distmoduledir']}"
      puppet_module_install(:source => directory, :module_name => module_name)
    end
    
    def install_hiera_on(host, fixtures_dir)
      files = [ 'hiera.yaml', 'hiera' ]
      files.each do |file|
        scp_to host, File.expand_path(File.join(fixtures_dir, file)), "/etc/puppet/#{file}"
      end
    end
    
    # Module installation (onto single host)
    def puppet_module_install_on(host, directory, module_name)
      #  # puppet_module_install(:source => proj_root, :module_name => 'razor')    
      #scp_to master, proj_root, File.join(master['distmoduledir'], 'razor')
    end
    
  end
end

include Beaker::Rcs

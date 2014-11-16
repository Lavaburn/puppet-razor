require 'spec_helper'

describe 'razor' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let(:pre_condition) { 
    "class { '::postgresql::server': }" 
  }

  context "ubuntu" do
  	  let(:facts) { {
	  	:osfamily 					      => 'debian',
	  	:operatingsystem 			    => 'Ubuntu',
	  	:lsbdistid					      => 'Ubuntu',
	  	:lsbdistcodename 			    => 'precise',
	  	:operatingsystemrelease 	=> '12.04',
	  	:concat_basedir  			    => '/tmp', # Concat
	  } }
	  
    let(:params) { {
      # Microkernel compilation is only supported on Redhat variants
      :compile_microkernel => false,    
    } }
	  
	  context "ubuntu_defaults" do	  
		  it { should compile.with_all_deps }
	  
      it { should contain_class('razor') }
        
      it { should contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should contain_class('razor::server') }
        
        
      it { should contain_package('razor-client') }    
        
      it { should contain_postgresql__server__db('razor_prod') }
        
      it { should contain_package('razor-server') }    
      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/
      it { should contain_file('/etc/razor/config.yaml').with_content($DB_regex) }
      it { should contain_exec('razor-migrate-database') }        
      it { should contain_service('razor-server') }       
    end
      
    context "ubuntu_without_client" do
	    let(:params) { {
        :compile_microkernel => false,
		  	:enable_client		   => false,		  	
		  } }
		  
		  it { should compile.with_all_deps }
		    
      it { should contain_class('razor') }
          
      it { should_not contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should contain_class('razor::server') }
	  end
	  
	  context "ubuntu_without_db" do
	    let(:params) { {		  	
        :compile_microkernel => false,
		  	:enable_db		       => false,		  	
		  } }
		  
		  it { should compile.with_all_deps }		  
		  
      it { should contain_class('razor') }
                
      it { should contain_class('razor::client') }
      it { should_not contain_class('razor::db') }
      it { should contain_class('razor::server') }
	  end
	  
	  context "ubuntu_without_server" do
	    let(:params) { {		 
        :compile_microkernel   => false, 	
		  	:enable_server		     => false,		  	
		  } }
		  
		  it { should compile.with_all_deps } 
      
      it { should contain_class('razor') }
                
      it { should contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should_not contain_class('razor::server') }
	  end
  end
  
  context "centos_defaults" do
  	let(:facts) { {
	    :osfamily 				           => 'redhat',
	  	:operatingsystem 		         => 'CentOS',
	  	:operatingsystemrelease      => '6.0',
	  	#:lsbmajdistrelease           => '6',
	  	:operatingsystemmajrelease   => '6',
	  	:concat_basedir  		         => '/tmp',
	  	:clientcert				           => 'centos',	# HIERA !!!
	  } }
  
  	# TODO it { should compile.with_all_deps }
  	# expected that the catalogue would include Package[tftp-server] 
  	# used at modules/tftp/manifests/init.pp:70 in Xinetd::Service[tftp]
  	# TODO - Module TFTP should be forked. Can't hard-copy package name to tftp-hpa in centos !!! 
    
    it { should contain_class('razor') }
              
    it { should contain_class('razor::client') }
    it { should contain_class('razor::db') }
    it { should contain_class('razor::server') }
      
      
    it { should contain_package('razor-client') }    
            
    it { should contain_postgresql__server__db('razor_prod') }
      
    it { should contain_package('razor-server') }    
    $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/
    it { should contain_file('/etc/razor/config.yaml').with_content($DB_regex) }
    it { should contain_exec('razor-migrate-database') }        
          
    it { should contain_file('/etc/yum.repos.d/epel.repo') }
    it { should contain_package('ruby193') }    
    it { should contain_vcsrepo('/opt/razor-el-mk') }                
    it { should contain_file('/opt/build-microkernel.sh') }   
    it { should contain_exec('build-microkernel') }        
  end  
end

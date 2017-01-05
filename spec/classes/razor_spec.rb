require 'spec_helper'

describe 'razor' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  let(:pre_condition) { 
    "
     class { '::postgresql::server': }
  #   class { '::tftp':
  #     directory => '/var/lib/tftpboot',
  #     address   => 'localhost',
  #   }
    "
  }
  
  context "ubuntu" do
   let(:facts) { {
	  	:osfamily 					      => 'Debian',
	  	:operatingsystem 			    => 'Ubuntu',
	  	:lsbdistid					      => 'Ubuntu',
      :lsbmajdistrelease        => '12.04',
	  	:lsbdistcodename 			    => 'precise',
	  	:operatingsystemrelease 	=> '12.04',
	  	:path                     => "/usr/local/bin:/opt/puppetlabs/bin",
	  	:concat_basedir  			    => '/tmp',
      :ipaddress                => '192.168.1.1',
      :puppetversion            => '4.0.0',
      :id                       => 'newfact1',
	  } }
	  
    let(:params) { {
      # Microkernel compilation is only supported on Redhat variants
      :compile_microkernel  => false,    
      :server_hostname      => '192.168.1.1',
      # Bug in tftp/xinetd ??? - Unknown variable: 'xinetd::params::service_status'
      :enable_tftp => false,   
    } }
    
	  context "ubuntu_defaults" do	  
		  it { should compile.with_all_deps }
	  
      it { should contain_class('razor') }
        
      it { should contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should contain_class('razor::server') }
      #TODO it { should contain_class('razor::tftp') }
      it { should contain_class('razor::microkernel') }
      it { should_not contain_class('razor::microkernel::compile') }
        
        
      it { should contain_package('razor-client') }    
        
      it { should contain_postgresql__server__db('razor_prod') }
        
      it { should contain_package('razor-server') }    
      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/      
      it { should contain_yaml_setting('production/database_url').with_value($DB_regex) }    
              
      it { should contain_exec('razor-migrate-database') }        
      it { should contain_service('razor-server') }       
                
      #TODO 
#      it { should contain_wget__fetch('http://boot.ipxe.org/undionly.kpxe') }
#      it { should contain_tftp__file('undionly.kpxe') }       
#	    it { should contain_wget__fetch('http://192.168.1.1:8080/api/microkernel/bootstrap').with(
#        'destination' => "/var/lib/tftpboot/bootstrap.ipxe"
#	    ) }       
#      it { should contain_tftp__file('bootstrap.ipxe') }
        
      it { should contain_archive('/tmp/razor-microkernel.tar').with(
        'source' => "http://links.puppetlabs.com/razor-microkernel-latest.tar"
      ) }
    end
      
    context "ubuntu_without_client" do
	    let(:params) { {
        :compile_microkernel => false,
		  	:enable_client		   => false,		  
        # Bug in tftp/xinetd ??? - Unknown variable: 'xinetd::params::service_status'
        :enable_tftp => false,	
		  } }
		  
		  it { should compile.with_all_deps }
		    
      it { should contain_class('razor') }
          
      it { should_not contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should contain_class('razor::server') }
      #TODO it { should contain_class('razor::tftp') }
      it { should contain_class('razor::microkernel') }
      it { should_not contain_class('razor::microkernel::compile') }
	  end
	  
	  context "ubuntu_without_db" do
	    let(:params) { {		  	
        :compile_microkernel => false,
		  	:enable_db		       => false,		 
        # Bug in tftp/xinetd ??? - Unknown variable: 'xinetd::params::service_status'
        :enable_tftp => false, 	
		  } }
		  
		  it { should compile.with_all_deps }		  
		  
      it { should contain_class('razor') }
                
      it { should contain_class('razor::client') }
      it { should_not contain_class('razor::db') }
      it { should contain_class('razor::server') }
      #TODO it { should contain_class('razor::tftp') }
      it { should contain_class('razor::microkernel') }
      it { should_not contain_class('razor::microkernel::compile') }
	  end
	  
	  context "ubuntu_without_server" do
	    let(:params) { {		 
        :compile_microkernel   => false, 	
		  	:enable_server		     => false,		  	
        # Bug in tftp/xinetd ??? - Unknown variable: 'xinetd::params::service_status'
        :enable_tftp => false,
		  } }
		  
		  it { should compile.with_all_deps } 
      
      it { should contain_class('razor') }
                
      it { should contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should_not contain_class('razor::server') }
      #TODO it { should contain_class('razor::tftp') }
      it { should contain_class('razor::microkernel') }
      it { should_not contain_class('razor::microkernel::compile') }
	  end
      
    context "ubuntu_without_tftp" do
      let(:params) { {     
        :compile_microkernel   => false,  
        :enable_tftp           => false,     
      } }
      
      it { should compile.with_all_deps } 
      
      it { should contain_class('razor') }
                
      it { should contain_class('razor::client') }
      it { should contain_class('razor::db') }
      it { should contain_class('razor::server') }
      #TODO it { should_not contain_class('razor::tftp') }
      it { should contain_class('razor::microkernel') }
      it { should_not contain_class('razor::microkernel::compile') }
    end
  end
  
  context "centos_defaults" do
  	let(:facts) { {
	    :osfamily 				           => 'RedHat',
	  	:operatingsystem 		         => 'CentOS',
	  	:operatingsystemrelease      => '6.0',
	  	:lsbmajdistrelease           => '6',
	  	:operatingsystemmajrelease   => '6',
      :path                        => "/usr/local/bin:/opt/puppetlabs/bin",
	  	:concat_basedir  		         => '/tmp',
	  	:clientcert				           => 'centos',	# HIERA !!!      
      :ipaddress                   => '192.168.1.1',
      :puppetversion               => '4.0.0',
      :id                          => 'newfact1',
	  } }
	  
    let(:params) { {     
      # Bug in tftp/xinetd ??? - Unknown variable: 'xinetd::params::service_status'
      :enable_tftp => false,
    } }
      
  	it { should compile.with_all_deps }
    
    it { should contain_class('razor') }
              
    it { should contain_class('razor::client') }
    it { should contain_class('razor::db') }
    it { should contain_class('razor::server') }
    #TODO it { should contain_class('razor::tftp') }
    it { should contain_class('razor::microkernel') }
    it { should contain_class('razor::microkernel::compile') }
      
    it { should contain_package('razor-client') }    
            
    it { should contain_postgresql__server__db('razor_prod') }
      
    it { should contain_package('razor-server') }    
    $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/
    it { should contain_yaml_setting('production/database_url').with_value($DB_regex) }    
    
    it { should contain_exec('razor-migrate-database') }        
          
    it { should contain_file('/etc/yum.repos.d/epel.repo') }
    it { should contain_package('ruby193') }    
    it { should contain_vcsrepo('/opt/razor-el-mk') }                
    it { should contain_file('/opt/build-microkernel.sh') }   
    it { should contain_exec('build-microkernel') }        
  end  
end

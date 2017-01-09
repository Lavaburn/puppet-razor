require 'spec_helper'

describe 'razor' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  let(:pre_condition) { 
    @dependencies
  }
  
  context "ubuntu" do
    let(:facts) {
      @ubuntu
    }
	  
	  context "defaults" do
      let(:params) { {        
        # Defaults  
      } }
      
      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/      
      
		  it { should compile.with_all_deps }
	  
      it { should contain_class('razor') }
        it { should contain_package('rest-client') }
        
      it { should contain_class('razor::client') }
        it { should contain_package('razor-client') }   
        
      it { should contain_class('razor::db') }
        it { should contain_postgresql__server__db('razor_prod') }
        
      it { should contain_class('razor::server') }
        it { should contain_package('razor-torquebox') }  
        it { should contain_package('razor-server') }  
        it { should contain_yaml_setting('production/database_url').with({
          'target' => '/etc/razor/config.yaml',          
          'value'  => $DB_regex
        })}
        it { should contain_yaml_setting('all/repo_store_root').with_value('/var/lib/razor/repo-store') }      
        it { should contain_service('razor-server') }   
        it { should contain_exec('razor-migrate-database').with({
          'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/razor/bin', '/opt/razor-torquebox/jruby/bin' ],
        })}
        it { should contain_exec('razor-redeploy').with({
          'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/razor-torquebox/jruby/bin' ],
          'command' => "bash -c 'source /etc/razor/razor-torquebox.sh; torquebox deploy /opt/razor --env=production'",
        })}    
      
        it { should contain_class('razor::microkernel') }
          it { should contain_class('archive') }
          it { should contain_archive('/tmp/razor-microkernel.tar').with(
            'source'       => "http://links.puppetlabs.com/razor-microkernel-latest.tar",
            'extract_path' => '/var/lib/razor/repo-store'
          ) }
          
      it { should contain_class('razor::tftp') }
        it { should contain_wget__fetch('http://boot.ipxe.org/undionly.kpxe') }
        it { should contain_tftp__file('undionly.kpxe') }       
        it { should contain_wget__fetch('http://192.168.1.1:8080/api/microkernel/bootstrap').with(
          'destination' => "/var/lib/tftpboot/bootstrap.ipxe"
        ) }       
        it { should contain_tftp__file('bootstrap.ipxe') }
      
      it { should_not contain_class('razor::microkernel::compile') }
    end
    
    context "Version 1.5.0" do
      let(:params) { {
        :server_package_version   => '1.5.0',
        :enable_new_ports_support => true,
        :enable_aio_support       => true,
      } }

      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/  
      
      it { should compile.with_all_deps }
                        
      it { should contain_yaml_setting('production/database_url').with({
        'target' => '/etc/puppetlabs/razor-server/config.yaml',          
        'value'  => $DB_regex
      })}
      
      it { should contain_yaml_setting('all/repo_store_root').with_value('/opt/puppetlabs/server/data/razor-server/repo') }   
     
      it { should contain_exec('razor-migrate-database').with({
        'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/puppetlabs/bin', '/opt/puppetlabs/server/apps/razor-server/bin' ],
      })}
      
      it { should contain_exec('razor-redeploy').with({
        'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/puppetlabs/server/apps/razor-server/sbin' ],
        'command' => "bash -c 'source /etc/puppetlabs/razor-server/razor-torquebox.sh; torquebox deploy /opt/puppetlabs/server/apps/razor-server/share/razor-server --env=production'",
      })}    
              
      it { should contain_archive('/tmp/razor-microkernel.tar').with(
        'source'       => "http://links.puppetlabs.com/razor-microkernel-latest.tar",
        'extract_path' => '/opt/puppetlabs/server/data/razor-server/repo'
      ) }
    end
  end

  context "centos 6.6" do
    let(:facts) {
      @centos
    }
    
    context "defaults" do
      let(:params) { {        
        # Defaults  
      } }
      
      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/      
      
      it { should compile.with_all_deps }
    
      it { should contain_class('razor') }
        it { should contain_package('rest-client') }
        
      it { should contain_class('razor::client') }
        it { should contain_package('razor-client') }   
        
      it { should contain_class('razor::db') }
        it { should contain_postgresql__server__db('razor_prod') }
        
      it { should contain_class('razor::server') }
        it { should contain_package('razor-torquebox') }  
        it { should contain_package('razor-server') }  
        it { should contain_yaml_setting('production/database_url').with({
          'target' => '/etc/razor/config.yaml',          
          'value'  => $DB_regex
        })}
        it { should contain_yaml_setting('all/repo_store_root').with_value('/var/lib/razor/repo-store') }      
        it { should contain_service('razor-server') }     
        it { should contain_exec('razor-migrate-database').with({
          'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/razor/bin', '/opt/razor-torquebox/jruby/bin' ],
        })}
        it { should contain_exec('razor-redeploy').with({
          'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/razor-torquebox/jruby/bin' ],
          'command' => "bash -c 'source /etc/razor/razor-torquebox.sh; torquebox deploy /opt/razor --env=production'",
        })}    

      it { should contain_class('razor::microkernel') }
          
      it { should contain_class('razor::tftp') }
        it { should contain_wget__fetch('http://boot.ipxe.org/undionly.kpxe') }
        it { should contain_tftp__file('undionly.kpxe') }       
        it { should contain_wget__fetch('http://192.168.1.1:8080/api/microkernel/bootstrap').with(
          'destination' => "/var/lib/tftpboot/bootstrap.ipxe"
        ) }       
        it { should contain_tftp__file('bootstrap.ipxe') }

      # No longer supported (hence disabled by default).
      it { should_not contain_class('razor::microkernel::compile') }
    end
    
    context "Version 1.5.0" do
      let(:params) { {
        :server_package_version   => '1.5.0',
        :enable_new_ports_support => true,
        :enable_aio_support       => true,
      } }

      $DB_regex = /jdbc:postgresql:\/\/localhost\/razor_prod\?user=razor&password=secret/  
      
      it { should compile.with_all_deps }
                        
      it { should contain_yaml_setting('production/database_url').with({
        'target' => '/etc/puppetlabs/razor-server/config.yaml',          
        'value'  => $DB_regex
      })}
      
      it { should contain_yaml_setting('all/repo_store_root').with_value('/opt/puppetlabs/server/data/razor-server/repo') }   
                    
      it { should contain_exec('razor-migrate-database').with({
        'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/puppetlabs/bin', '/opt/puppetlabs/server/apps/razor-server/bin' ],
      })}
      
      it { should contain_exec('razor-redeploy').with({
        'path' => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/puppetlabs/server/apps/razor-server/sbin' ],
        'command' => "bash -c 'source /etc/puppetlabs/razor-server/razor-torquebox.sh; torquebox deploy /opt/puppetlabs/server/apps/razor-server/share/razor-server --env=production'",
      })}    
              
      it { should contain_archive('/tmp/razor-microkernel.tar').with(
        'source'       => "http://links.puppetlabs.com/razor-microkernel-latest.tar",
        'extract_path' => '/opt/puppetlabs/server/data/razor-server/repo'
      ) }
    end
  end
  
  context "centos 7.2" do
    let(:facts) {
      @centos.merge({
        :operatingsystemrelease      => '7.2',
        :lsbmajdistrelease           => '7',
        :operatingsystemmajrelease   => '7',
      })
    }
    
    let(:params) { {
      # Defaults
    } }
    
    context "defaults" do
      it { should contain_class('razor::microkernel::compile') }
        it { should contain_package('git') }
        it { should contain_package('livecd-tools') }
        it { should contain_vcsrepo('/opt/razor-el-mk') }
        it { should contain_file('/opt/build-microkernel.sh') }
        it { should contain_exec('build-microkernel').with(
          'cwd'     => "/opt/razor-el-mk",
          'command' => '/opt/build-microkernel.sh',
          'creates' => '/opt/razor-el-mk/pkg/microkernel.tar'
        ) }
    end
  end
end

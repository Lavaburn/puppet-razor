require 'spec_helper_acceptance'

describe 'razor class' do
  # TODO 0.16.1-1puppet1
  # TODO 1.0.1-1puppet1
  # TODO 1.1.0-1puppet1
  # TODO 1.2.0-1puppet1
  
  describe 'ubuntu razor 1.3.0' do    
    it 'should install and be idempotent' do
      enable_puppetlabs3()
    
      pp = <<-EOS      
        class { '::postgresql::server': }

        class { '::tftp':
          directory => '/var/lib/tftpboot',
          address   => 'localhost',
        }

        class { '::razor':
          server_package_version => '1.3.0-1puppet1',
          compile_microkernel    => false,
 
          # Changed in 1.1.0 from 8080 to 8150
          server_http_port       => 8150,
          server_https_port      => 8151,
        }
      EOS

      # Run it twice and test for idempotency
      agents.each do |agent|
        if agent['platform'] =~ /ubuntu/
          apply_manifest_on(agent, pp, :catch_failures => true)
          expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
        end 
      end
    end
  end
        
  # TODO 1.4.0-1puppet1
  # TODO 1.5.0-1puppet1

#  describe 'ubuntu razor 1.5' do    
#    it 'should install and be idempotent' do
#      pp = <<-EOS
#        class { '::postgresql::server': }
#        class { '::tftp':
#          directory => '/var/lib/tftpboot',
#          address   => 'localhost',
#        }
#        class { 'razor':
#          compile_microkernel   => false,
#          root_dir              => '/opt/puppetlabs/server/apps/razor-server',
#          data_dir              => '/opt/puppetlabs/server/data/razor-server',
#          repo_store            => '/opt/puppetlabs/server/data/razor-server/repo',
#          server_http_port      => 8150,
#          server_https_port     => 8151        
#        }
#      EOS
#
#      # Run it twice and test for idempotency
#      agents.each do |agent|
#        if agent['platform'] =~ /ubuntu/
#          apply_manifest_on(agent, pp, :catch_failures => true)
#          expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
#        end 
#      end
#    end
#  end

#  describe 'razor defaults' do    
#    it 'should work with no errors' do
#      pp = <<-EOS
#              class { '::postgresql::server': }
#              class { 'razor': }
#           EOS
#           
#      # Run it twice and test for idempotency
#      agents.each do |agent|
#        if agent['platform'] =~ /centos/
#          # Microkernel compilation is only support on RHEL/CentOS/Fedora
#          
#          # CentOS 6.5 currently uses verion too old for razor DB migrate
#            # https://groups.google.com/forum/#!topic/puppet-razor/Cxcz56GXUbk
#          
#          #apply_manifest_on(agent, pp, :catch_failures => true)            
#          #expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
#        end 
#      end
#    end
#  end
#  
#  describe 'razor microkernel only' do    
#    it 'should work with no errors' do
#      pp = <<-EOS
#        class { 'razor': 
#          enable_client  => false,
#          enable_db      => false,
#          enable_server  => false,
#          enable_tftp    => false,
#        }
#     EOS
#           
#      # Run it twice and test for idempotency
#      agents.each do |agent|
#        if agent['platform'] =~ /centos/
#          apply_manifest_on(agent, pp, :catch_failures => true)            
#          expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
#        end 
#      end
#    end
#  end
#  
#  describe 'razor without microkernel compilation' do    
#    it 'should work with no errors' do
#      pp = <<-EOS
#        class { '::postgresql::server': }
#        class { '::tftp':
#          directory => '/var/lib/tftpboot',
#          address   => 'localhost',
#        }
#        class { 'razor': 
#          compile_microkernel   => false,
#          root_dir              => '/opt/puppetlabs/server/apps/razor-server',
#          data_dir              => '/opt/puppetlabs/server/data/razor-server',
#          repo_store            => '/opt/puppetlabs/server/data/razor-server/repo',
#          server_http_port      => 8150,
#          server_https_port     => 8151
#        }
#     EOS
#    
#      # Run it twice and test for idempotency
#      agents.each do |agent|
#        if agent['platform'] =~ /ubuntu/      
#          apply_manifest_on(agent, pp, :catch_failures => true)            
#          expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
#        end
#      end
#    end  
#  end
end
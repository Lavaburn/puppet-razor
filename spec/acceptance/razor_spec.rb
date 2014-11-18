require 'spec_helper_acceptance'

describe 'razor class' do
  describe 'razor defaults' do    
    it 'should work with no errors' do
      pp = <<-EOS
              class { '::postgresql::server': }
              class { 'razor': }
           EOS
           
      # Run it twice and test for idempotency
      agents.each do |agent|
        if agent['platform'] =~ /centos/
          # Microkernel compilation is only support on RHEL/CentOS/Fedora
          
          # CentOS 6.5 currently uses verion too old for razor DB migrate
            # https://groups.google.com/forum/#!topic/puppet-razor/Cxcz56GXUbk
          
          #apply_manifest_on(agent, pp, :catch_failures => true)            
          #expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
        end 
      end
    end
  end
  
  describe 'razor microkernel only' do    
    it 'should work with no errors' do
      pp = <<-EOS
              class { 'razor': 
                enable_client  => false,
                enable_db      => false,
                enable_server  => false,
                enable_tftp    => false,
              }
           EOS
           
      # Run it twice and test for idempotency
      agents.each do |agent|
        if agent['platform'] =~ /centos/
          apply_manifest_on(agent, pp, :catch_failures => true)            
          expect(apply_manifest_on(agent, pp, :catch_failures => true).exit_code).to be_zero
        end 
      end
    end
  end
  
  describe 'razor without microkernel' do    
    it 'should work with no errors' do
      pp = <<-EOS
              class { '::postgresql::server': }
              class { '::tftp':
                directory => '/var/lib/tftpboot',
                address   => 'localhost',
              }
              class { 'razor': 
                compile_microkernel   => false,
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
end
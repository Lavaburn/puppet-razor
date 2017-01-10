require 'spec_helper_acceptance'

describe 'razor custom types' do  
  context 'setup API config' do   
    #before { skip("Skipping API config setup") }
    
    let(:pp) {
      <<-EOS  
        class { 'razor::api': }
      EOS
    }
    
    it_behaves_like 'an idempotent manifest'
  end

  context 'custom types creation' do   
    #before { skip("Skipping creation of custom types") }
    
    let(:pp) {
      <<-EOS  
        razor_broker { 'xenserver-dev':
          ensure        => 'present',
          broker_type   => 'puppet-xenserver',
          configuration => {
            'server'      => 'puppetserver',
            'environment' => 'dev'
          },
        }
            
        razor_tag { 'physical':
          ensure => 'present',
          rule   => ['=', ['fact', 'is_virtual'], false]
        }
      
        razor_repo { 'xenserver-6.5':
          ensure  => 'present',
          iso_url => 'http://downloadns.citrix.com.edgesuite.net/akdlm/10175/XenServer-6.5.0-xenserver.org-install-cd.iso',
          task    => 'xenserver',
        }
        
        razor_policy { 'physical_servers':
          ensure        => 'present',
          repo          => 'xenserver-6.5',
          task          => 'xenserver',
          broker        => 'xenserver-dev',
          hostname      => 'host-${id}',
          root_password => 'password',
          max_count     =>  20,
          node_metadata => {},
          tags          => ['physical'],
        }
      EOS
    }
    
    it_behaves_like 'an idempotent manifest'
  end  
end

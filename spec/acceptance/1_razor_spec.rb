require 'spec_helper_acceptance'

describe 'razor class' do    
  # Version 1.0.0 - 1.0.1 - first "stable" - no longer supporting 0.x
  context 'razor 1.0.1 without microkernel' do    
    before { skip("Skipping installation of 1.0.1") }

    let(:repository) { 'puppetlabs3' }
    let(:version) { '1.0.1' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, false, false)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8080, '/var/lib/razor/repo-store/microkernel', '1.0.1'
  end

  context 'upgrade razor 1.0.1 to 1.3.0' do   
    #before { skip("Skipping upgrade from 1.0.1 to 1.3.0") }
      
    it 'should stop the service before upgrading' do
      stop_razor()
    end
  end
  
  # Version 1.1.0 - 1.3.0 - Port change from 8080 to 8150  
  context 'razor 1.3.0 without microkernel' do    
    #before { skip("Skipping installation of 1.3.0") }

    let(:repository) { 'puppetlabs3' }
    let(:version) { '1.3.0' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, false)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/var/lib/razor/repo-store/microkernel', '1.3.0'
  end

  context 'upgrade razor 1.3.0 to 1.5.0' do   
    #before { skip("Skipping upgrade from 1.3.0 to 1.5.0") }
      
    it 'should stop the service before upgrading' do
      stop_razor()
    end
  end

  # Version 1.3.0 - 1.5.0 - Paths updated for AIO packaging
  context 'razor 1.5.0 without microkernel' do    
    #before { skip("Skipping installation of 1.5.0") }

    let(:repository) { 'pc1' }
    let(:version) { '1.5.0' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
  end
  
  context 'upgrade razor 1.5.0 to 1.6.1' do   
    before { skip("Skipping upgrade from 1.5.0 to 1.6.1") }
      
    it 'should stop the service before upgrading' do
      stop_razor()
    end
  end
  
  # TODO: PROBLEM !!!
#  Attempting to undeploy razor-server-knob.yml
#  Can't undeploy /opt/puppetlabs/server/apps/razor-server/share/torquebox/jboss/standalone/deployments/razor-server-knob.yml. It does not appear to be deployed.
#  Attempting to undeploy razor-server.knob
#  Can't undeploy /opt/puppetlabs/server/apps/razor-server/share/torquebox/jboss/standalone/deployments/razor-server.knob. It does not appear to be deployed.
  # Version 1.5.0 - 1.6.1
  context 'razor 1.6.1 without microkernel' do    
    before { skip("Skipping installation of 1.6.1") }

    let(:repository) { 'pc1' }
    let(:version) { '1.6.1' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
  end
  
  # Version 1.6.1 - 1.7.1
  context 'razor 1.7.1 without microkernel' do    
    before { skip("Skipping installation of 1.7.1") }

    let(:repository) { 'pc1' }
    let(:version) { '1.7.1' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
  end
  
  # Version 1.7.1 - 1.8.1
  context 'razor 1.8.1 without microkernel' do    
    before { skip("Skipping installation of 1.8.1") }

    let(:repository) { 'pc1' }
    let(:version) { '1.8.1' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
  end
  
  # Version 1.8.0 - 1.9.1
  context 'razor 1.9.1 without microkernel' do    
    before { skip("Skipping installation of 1.9.1") }

    let(:repository) { 'pc1' }
    let(:version) { '1.9.1' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
  end
    
  context 'downgrade razor 1.9.1 to 1.1.0' do   
    before { skip("Skipping downgrade from 1.9.1 to 1.1.0") }
      
    it 'should stop the service before upgrading' do
      stop_razor()
    end
  end
 
  # Version 1.1.0
  context 'razor 1.1.0 without microkernel' do    
    before { skip("Skipping installation of 1.1.0") }

    let(:repository) { 'puppetlabs3' }
    let(:version) { '1.1.0' }
    let(:razor_pp) { 
      get_default_razor_manifest(version, repository, true, false)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp, extra_resources())
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
        
    it_behaves_like 'an idempotent manifest'
    it_behaves_like 'a running razor server', 8150, '/var/lib/razor/repo-store/microkernel', '1.1.0'
  end

  context 'upgrade razor 1.1.0 to 1.9.1' do   
    before { skip("Skipping upgrade from 1.1.0 to 1.9.1") }
      
    it 'should stop the service before upgrading' do
      stop_razor()
    end
  end

  # Microkernel compilation
  context 'microkernel compilation' do
    before { skip("Not testing compilation") }

    let(:repository) { 'pc1' }
    let(:version) { '1.5.0' }
    let(:razor_pp) { 
      get_compilation_manifest(version, repository, true, true)
    }
    let(:pp) {
      build_manifest(dependencies(), razor_pp)
    }
    
    it 'should setup the correct repository' do
      setup_repository(repository)
    end
    
    it_behaves_like 'an idempotent manifest'
    
    it_behaves_like 'a running razor server', 8150, '/opt/puppetlabs/server/data/razor-server/repo/microkernel', "DEVELOPMENT"
      
    it_behaves_like 'a valid microkernel image'
  end
end

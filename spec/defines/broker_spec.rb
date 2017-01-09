require 'spec_helper'

describe 'razor::broker', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  context "ubuntu" do
    let(:facts) {
      @ubuntu
    }
    
    let(:title) { 'puppet-xenserver' }
    
    context "defaults" do    
      let(:pre_condition) { 
        @dependencies + @razor_default
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/razor/brokers/puppet-xenserver.broker').with(
        'source' => "puppet:///modules/razor/brokers/puppet-xenserver.broker"
      ) }
    end
    
    context "aio_support" do    
      let(:pre_condition) { 
        @dependencies + @razor_default_aio
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/brokers/puppet-xenserver.broker').with(
        'source' => "puppet:///modules/razor/brokers/puppet-xenserver.broker"
      ) }
    end    
  end

  context "centos" do
    let(:facts) {
      @centos
    }
    
    let(:title) { 'puppet-xenserver' }
    
    context "defaults" do    
      let(:pre_condition) { 
        @dependencies + @razor_default
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/razor/brokers/puppet-xenserver.broker').with(
        'source' => "puppet:///modules/razor/brokers/puppet-xenserver.broker"
      ) }
    end
    
    context "aio_support" do    
      let(:pre_condition) { 
        @dependencies + @razor_default_aio
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/brokers/puppet-xenserver.broker').with(
        'source' => "puppet:///modules/razor/brokers/puppet-xenserver.broker"
      ) }
    end    
  end
end

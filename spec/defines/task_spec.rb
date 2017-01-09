require 'spec_helper'

describe 'razor::task', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
      
  context "ubuntu" do
    let(:facts) {
      @ubuntu
    }
    
    let(:title) { 'xenserver' }
    
    context "defaults" do
      let(:pre_condition) { 
        @dependencies + @razor_default
      }
      
      it { should compile.with_all_deps }

      it { should contain_file('/opt/razor/tasks/xenserver.task').with(
        'source' => "puppet:///modules/razor/tasks/xenserver.task"
      ) }
    end
    
    context "aio_support" do    
      let(:pre_condition) { 
        @dependencies + @razor_default_aio
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/tasks/xenserver.task').with(
        'source' => "puppet:///modules/razor/tasks/xenserver.task"
      ) }
    end   
  end
  
  context "centos" do
    let(:facts) {
      @centos
    }
    
    let(:title) { 'xenserver' }
    
    context "defaults" do
      let(:pre_condition) { 
        @dependencies + @razor_default
      }
      
      it { should compile.with_all_deps }

      it { should contain_file('/opt/razor/tasks/xenserver.task').with(
        'source' => "puppet:///modules/razor/tasks/xenserver.task"
      ) }
    end
    
    context "aio_support" do    
      let(:pre_condition) { 
        @dependencies + @razor_default_aio
      }
      
      it { should compile.with_all_deps }
        
      it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/tasks/xenserver.task').with(
        'source' => "puppet:///modules/razor/tasks/xenserver.task"
      ) }
    end   
  end
end

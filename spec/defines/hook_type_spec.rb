require 'spec_helper'

describe 'razor::hook_type', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  on_supported_os(
    :supported_os => [
      {
        "operatingsystem" => "Ubuntu",
        "operatingsystemrelease" => [
          "12.04",
          "14.04",
          "16.04"
        ]
      },
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => [
          "6.5",
          "7.0.1406"
        ]
      },
    ]
  ).each do |os, facts|
    context "on #{os}" do
      let(:facts) {
        facts
      }
      
      let(:title) { 'my_custom_hook_type' }

      context "defaults" do
        let(:pre_condition) { 
          dependencies() + razor_default()
        }
        
        it { should compile.with_all_deps }
  
        it { should contain_file('/opt/razor/hooks/my_custom_hook_type.hook').with(
          'source' => "puppet:///modules/razor/hooks/my_custom_hook_type.hook"
        ) }
      end
      
      context "aio_support" do    
        let(:pre_condition) { 
          dependencies() + razor_default_aio()
        }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/hooks/my_custom_hook_type.hook').with(
          'source' => "puppet:///modules/razor/hooks/my_custom_hook_type.hook"
        ) }
      end   
  
      context "default_custom_source" do
        let(:pre_condition) { 
          dependencies() + razor_default()
        }
  
        let(:params) { {
          :module     => 'mymodule',
          :directory  => 'myhooks',
        } }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/opt/razor/hooks/my_custom_hook_type.hook').with(
          'source' => "puppet:///modules/mymodule/myhooks/my_custom_hook_type.hook"
        ) }
      end   
      
      context "aio_custom_paths" do
        let(:pre_condition) { 
          dependencies() + razor_default_aio()
        }
  
        let(:params) { {
          :root     => '/tmp/hooks',
          :source   => 'http://hooks/hook1',
        } }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/tmp/hooks/my_custom_hook_type.hook').with(
          'source' => "http://hooks/hook1"
        ) }
      end          
    end
  end
end

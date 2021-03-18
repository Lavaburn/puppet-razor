require 'spec_helper'

describe 'razor::task', :type => :define do
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
        
      let(:title) { 'xenserver' }
      
      context "defaults" do
        let(:pre_condition) { 
          dependencies() + razor_default()
        }
        
        it { should compile.with_all_deps }
  
        it { should contain_file('/opt/razor/tasks/xenserver.task').with(
          'source' => "puppet:///modules/razor/tasks/xenserver.task"
        ) }
      end
      
      context "aio_support" do    
        let(:pre_condition) { 
          dependencies() + razor_default_aio()
        }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/opt/puppetlabs/server/apps/razor-server/share/razor-server/tasks/xenserver.task').with(
          'source' => "puppet:///modules/razor/tasks/xenserver.task"
        ) }
      end   
  
      context "default_custom_source" do
        let(:pre_condition) { 
          dependencies() + razor_default()
        }
  
        let(:params) { {
          :module     => 'mymodule',
          :directory  => 'mytasks',
        } }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/opt/razor/tasks/xenserver.task').with(
          'source' => "puppet:///modules/mymodule/mytasks/xenserver.task"
        ) }
      end   
      
      context "aio_custom_paths" do
        let(:pre_condition) { 
          dependencies() + razor_default_aio()
        }
  
        let(:params) { {
          :root     => '/tmp/tasks',
          :source   => 'http://tasks/task1',
        } }
        
        it { should compile.with_all_deps }
          
        it { should contain_file('/tmp/tasks/xenserver.task').with(
          'source' => "http://tasks/task1"
        ) }
      end
    end      
  end
end

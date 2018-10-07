require 'spec_helper'

describe 'razor::api' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  let(:pre_condition) { 
    dependencies()
  }

  on_supported_os(
    :supported_os => [
      {
        "operatingsystem" => "Ubuntu",
        "operatingsystemrelease" => [
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
  	  context "fact razor 1.0.1" do
        let(:facts) {
          facts.merge({
            :razorserver_version => '1.0.1'
          })
        }
        
        let(:params) { {        
          # Defaults  
        } }
        
  		  it { should compile.with_all_deps }
  		  
  		  it { should contain_file('/etc/razor') }
  		  it { should contain_file('/etc/razor/api.yaml').with_content(
  		    /api_port: 8080/
  		  ) }		    
        it { should contain_package('rest-client') }
      end
  
      context "fact razor 1.1.0" do
        let(:facts) {
          facts.merge({
            :razorserver_version => '1.1.0'
          })
        }
        
        let(:params) { {        
          # Defaults  
        } }
        
        it { should compile.with_all_deps }
        
        it { should contain_file('/etc/razor') }
        it { should contain_file('/etc/razor/api.yaml').with_content(
          /api_port: 8150/
        ) }        
        it { should contain_package('rest-client') }
      end
      
      context "Version 1.5.0" do
        let(:facts) {
          facts
        }
        
        let(:params) { {
          :port   => 8081,
        } }
        
        it { should compile.with_all_deps }
        
        it { should contain_file('/etc/razor') }
        it { should contain_file('/etc/razor/api.yaml').with_content(
          /api_port: 8081/
        ) }        
        it { should contain_package('rest-client') }
      end
    end
  end
end

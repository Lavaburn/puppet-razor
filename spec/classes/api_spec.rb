require 'spec_helper'

describe 'razor::api' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  let(:pre_condition) { 
    @dependencies
  }
  
  context "ubuntu" do
	  context "fact razor 1.0.1" do
      let(:facts) {
        @ubuntu.merge({
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
        @ubuntu.merge({
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
        @ubuntu
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

  context "centos" do
    context "fact razor 1.0.1" do
      let(:facts) {
        @centos.merge({
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
        @centos.merge({
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
        @centos
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

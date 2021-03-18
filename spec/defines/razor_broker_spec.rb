require "spec_helper"

describe "razor_broker", :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let (:title) { "example" }
    
  context "defaults" do
    let (:params) {{
      :broker_type => "type",
      :configuration => {},
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_broker('example').with(
      :broker_type             => 'type',
      :configuration         => {}
    )}
  end
end

require "spec_helper"

describe "razor_tag", :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let (:title) { "example" }
    
  context "defaults" do
    let (:params) {{
      :rule => [ "rule1" ]
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_tag('example').with(
      :rule => [ "rule1" ]
    )}
  end
end

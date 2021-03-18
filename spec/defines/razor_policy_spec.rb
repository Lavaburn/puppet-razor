require "spec_helper"

describe "razor_policy", :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
    
  let (:title) { "example" }
    
  context "defaults" do
    let (:params) {{
      # TODO
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_policy('example').with(

    )}
  end
end

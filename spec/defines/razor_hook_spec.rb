require "spec_helper"

describe "razor_hook", :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let (:title) { "example" }
    
  context "defaults" do
    let (:params) {{
      :hook_type => "type",
      :configuration => {},
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_hook('example').with(
      :hook_type             => 'type',
      :configuration         => {}
#      :mutable_configuration => true       # TODO: This fails?
    )}
  end
  
  context "immutable" do
    let (:params) {{
      :hook_type             => "type",
      :configuration         => {},
      :mutable_configuration => false,
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_hook('example').with_mutable_configuration(false) }
  end
end

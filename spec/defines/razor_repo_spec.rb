require "spec_helper"

describe "razor_repo", :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let (:title) { "example" }
    
  context "url" do
    let (:params) {{
      :task => "my_task",
      :url  => "http://myurl/myiso.iso",
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_repo('example').with(
      :task => 'my_task',
      :url  => "http://myurl/myiso.iso"
    )}
  end
  
  context "iso_url" do
    let (:params) {{
      :task    => "my_task",
      :iso_url => "http://myurl/myiso.iso",
    }}
    
    it { should compile.with_all_deps }
    it { should contain_razor_repo('example').with_iso_url("http://myurl/myiso.iso") }
  end
end

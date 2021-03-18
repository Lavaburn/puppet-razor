require 'spec_helper'
describe 'razor_hook', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
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
      let(:facts) {
        facts
      }
      let(:title) { 'my_custom_hook' }
      let(:params) {{
        :hook_type => 'my_custom_hook_type',
        :configuration => {},
      }}
      context "defaults" do
        let(:pre_condition) {
          dependencies() + razor_default()
        }
        it { should compile.with_all_deps }
        it { should contain_razor_hook('my_custom_hook').with(
          :hook_type => 'my_custom_hook_type',
          :configuration => {},
        )}
      end
    end
  end
end
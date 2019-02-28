require 'spec_helper'
describe 'razor::hook_type', :type => :define do
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
      default_data_dir = '/default/data/dir'
      hook_type_name = 'my_custom_hook_type'
      hook_type_source_dir = 'puppet:///modules/custom_hook_type_directory'
      let(:title) { hook_type_name }
      let(:params) {{
        :source => hook_type_source_dir,
      }}
      context "defaults" do
        let(:pre_condition) {
          dependencies() + "
          class { '::razor':
            enable_tftp => false,
            data_dir    => '#{default_data_dir}',
          }"
        }
        it { should compile.with_all_deps }
        it { should contain_razor__hook_type(hook_type_name).with(
          :source => hook_type_source_dir,
          :root   => "#{default_data_dir}/hooks",
        )}
        it { should contain_file(
          "#{default_data_dir}/hooks/#{hook_type_name}.hook").with(
            'ensure' => 'directory')
        }
      end
    end
  end
end
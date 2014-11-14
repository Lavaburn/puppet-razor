require 'spec_helper'

describe 'example' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  context "ubuntu_defaults" do
    let(:facts) { {
      :osfamily         => 'debian',
      :operatingsystem  => 'Ubuntu',
      :lsbdistid         => 'Ubuntu',
      :lsbdistcodename   => 'saucy',
    } }

   it { should compile.with_all_deps }


  end

  context "centos_defaults" do
    let(:facts) { {
      :osfamily               => 'redhat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0',
    } }

    it { should compile.with_all_deps }


  end
end
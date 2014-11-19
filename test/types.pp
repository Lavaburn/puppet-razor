razor_broker { 'puppet-dev':
  ensure        => 'present',
  broker_type   => 'puppet',
  configuration => {
    'server'        => 'puppet',
    'environment'   => 'dev'
  },
}

razor_repo { 'ubuntu-14.04.1':
  ensure  => 'present',
  iso_url => 'http://releases.ubuntu.com/14.04.1/ubuntu-14.04.1-server-amd64.iso',
  task    => 'ubuntu',
}

razor_tag { 'hypervisor':
  ensure  => 'present',
  rule    => ["=", ["fact", "processorcount"], "4"]
}
# >= requires numeric value and puppet can't seem to figure out numbers???

razor_policy { 'install_ubuntu_on_hypervisor':
  ensure         => 'present',
  repo           => 'ubuntu-14.04.1',
	task           => 'ubuntu',
	broker         => 'puppet-dev',
	hostname       => 'host${id}.rcswimax.com',
	root_password  => 'nieuwrootpw',
	max_count      => undef,
  #before|after   => 'policy2',
  node_metadata  => {},
	tags           => ['hypervisor'],
}

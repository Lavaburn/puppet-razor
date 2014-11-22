Class['razor'] ->
razor_broker { 'puppet-dev':
  ensure        => 'present',
  broker_type   => 'puppet',
  configuration => {
    'server'      => 'puppet',
    'environment' => 'dev'
  },
}

Class['razor'] ->
razor_repo { 'ubuntu-14.04.1':
  ensure  => 'present',
  iso_url => 'http://releases.ubuntu.com/14.04.1/ubuntu-14.04.1-server-amd64.iso',
  task    => 'ubuntu',
}

Class['razor'] ->
razor_tag { 'small':
  ensure => 'present',
  rule   => ['=', ['fact', 'processorcount'], '1']
} # TODO >= requires numeric value and puppet can't seem to figure out numbers???

Class['razor'] ->
razor_policy { 'install_ubuntu_on_hypervisor':
  ensure        => 'present',
  repo          => 'ubuntu-14.04.1',
  task          => 'ubuntu',
  broker        => 'puppet-dev',
  hostname      => 'host${id}.test.com',
  root_password => 't3mporary',
  max_count     =>  undef,      # TODO - setting undef only works on create, does not trigger update !!
  # before_policy  => 'policy0',
  node_metadata => {},
  tags          => ['small'],
}

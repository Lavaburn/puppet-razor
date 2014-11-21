# Puppet Module for Razor

####Table of Contents

1. [Overview](#overview)
2. [Dependencies](#dependencies)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Compatibility](#compatibility)
6. [Testing](#testing)
7. [Copyright](#copyright)

##Overview

This module installs and sets up Razor.

##Dependencies

The Database should be postgres >= 9.1

Modules:
- puppetlabs/stdlib (REQUIRED)
- puppetlabs/postgresql (Optional)
  * puppetlabs/apt (postgresql)
  * puppetlabs/concat (postgresql)
- puppetlabs/vcsrepo (Optional)
- [https://github.com/lavaburn/puppetlabs-tftp.git] (Optional)
  * puppetlabs/xinetd (tftp)
- maestrodev/wget (Optional/tftp)
- [https://github.com/lavaburn/puppet-archive.git] (Optional)

* If you want to set up PostgreSQL config:
  	- `include 'posgresql::server'`	[puppetlabs/postgresql]
* If you want to compile the Microkernel (on Fedora/CentOS/RHEL)
	- puppetlabs/vcsrepo module 
* If you want to set up TFTP boot files
	- `include 'wget'`
	- `class { '::tftp': }`		[puppetlabs/tftp]
* If you want to download/extract a microkernel, 
	- Do not set microkernel_url to undef. (Default : puppetlabs precompiled)
	- lavaburn/archive module	
	
##Usage
     
It is highly recommended to put secret keys in Hiera-eyaml and use automatic parameter lookup
* [https://github.com/TomPoulton/hiera-eyaml]
* [https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup]

Make sure to include all dependencies as per above.

Also see the examples/profile.pp file for an example on how to set up dependencies.   
     
```
  class { 'razor':
    db_hostname => '127.0.0.1',
    db_password => 'notasecretpassword',
  } 
```

##Reference

You should only use the 'razor' class.

### Types

#### razor_broker
```
razor_broker { 'puppet-dev':
  ensure        => 'present',
  broker_type   => 'puppet',
  configuration => {
    'server'      => 'puppet',
    'environment' => 'dev'
  },
}
```
- name: The broker name
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- broker_type: The broker type
- configuration: The broker configuration (Hash)
- provider: The specific backend to use for this `razor_broker` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
  * rest: REST provider for Razor broker

#### razor_policy
```
razor_policy { 'install_ubuntu_on_hypervisor':
  ensure        => 'present',
  repo          => 'ubuntu-14.04.1',
  task          => 'ubuntu',
  broker        => 'puppet-dev',
  hostname      => 'host${id}.test.com',
  root_password => 't3mporary',
  max_count     =>  undef,
  before_policy => 'policy0',
  node_metadata => {},
  tags          => ['small'],
}
```
- name: The policy name
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- repo: The repository to install from
- task: The task to use to install the repo
- broker: The broker to use after installation
- hostname: The hostname to set up (use ${id} inside)
- root_password: The root password to install with
- max_count: The maximum hosts to configure (set nil for unlimited)
- after_policy: The policy after this one
- before_policy: The policy before this one
- node_metadata: The node metadata [Hash]
- tags: The tags to look for [Array]
- provider: The specific backend to use for this `razor_policy` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
  * rest: REST provider for Razor broker

#### razor_repo
```
razor_repo { 'ubuntu-14.04.1':
  ensure  => 'present',
  iso_url => 'http://releases.ubuntu.com/14.04.1/ubuntu-14.04.1-server-amd64.iso',
  task    => 'ubuntu',
}
```
- name: The repository name
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- iso_url: The URL of the ISO to download
- url: The URL of a mirror (no downloads)
- task: The default task to perform to install the OS
- provider: The specific backend to use for this `razor_repo` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
  * rest: REST provider for Razor broker

#### razor_tag
```
razor_tag { 'small':
  ensure => 'present',
  rule   => ['=', ['fact', 'processorcount'], '1']
}
```
- name: The tag name
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- rule: The tag rule (Array)   
- provider: The specific backend to use for this `razor_tag` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
  * rest: REST provider for Razor broker

##Compatibility

This module has been tested with:
* Puppet 3.7.3 - Ruby 1.9.3 - Ubuntu 12.04
* Puppet 3.7.3 - Ruby 1.8.7 - CentOS 6.3

* compile_microkernel can only work on RHEL/CentOS/Fedora
* enable_server requires Postgres >= 9.1

##Testing

Dependencies:
- Ruby
- Bundler (gem install bundler)

If you wish to test this module yourself:
1. bundle
2. rake test

For running acceptance testing (beaker/vagrant):
1. rake acceptance
(TODO - DEPENDENCIES)

##Copyright

   Copyright 2014 Nicolas Truyens

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

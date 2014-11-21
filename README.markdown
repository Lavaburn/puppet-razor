# Puppet Module for Razor

####Table of Contents

1. [Overview](#overview)
2. [Dependencies](#dependencies)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Compatibility](#compatibility)
6. [Testing](#testing)
7. [Copyright] (#copyright)

##Overview

This module installs and sets up Razor.

##Dependencies

The Database should be postgres >= 9.1

Modules:
- puppetlabs/stdlib (REQUIRED)
- puppetlabs/postgresql (Optional)
	- puppetlabs/apt (postgresql)
	- puppetlabs/concat (postgresql)
- puppetlabs/vcsrepo (Optional)
- puppetlabs/tftp (Optional)
	- puppetlabs/xinetd (tftp)
- maestrodev/wget (Optional/tftp)
- lavaburn/archive (Optional)

* If you want to set up PostgreSQL config:
  	- include 'posgresql::server'	[puppetlabs/postgresql]
* If you want to compile the Microkernel (on Fedora/CentOS/RHEL)
	- puppetlabs/vcsrepo module 
* If you want to set up TFTP boot files
	- include 'wget'
	- class { '::tftp': }		[puppetlabs/tftp]
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
- broker_type: The broker type
- configuration: The broker configuration (Hash)
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- name: The broker name
- provider: The specific backend to use for this `razor_broker` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
- rest: REST provider for Razor broker

#### razor_policy
- after_policy: The policy after this one
- before_policy: The policy before this one
- broker: The broker to use after installation
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- hostname: The hostname to set up (use ${id} inside)
- max_count: The maximum hosts to configure (set nil for unlimited)
- name: The policy name
- node_metadata: The node metadata [Hash]
- provider: The specific backend to use for this `razor_broker` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
- rest: REST provider for Razor broker
- repo: The repository to install from
- root_password: The root password to install with
- tags: The tags to look for [Array]
- task: The task to use to install the repo

#### razor_repo
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- iso_url: The URL of the ISO to download
- name: The repository name
- provider: The specific backend to use for this `razor_broker` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
- rest: REST provider for Razor broker
- task: The default task to perform to install the OS
- url: The URL of a mirror (no downloads)

#### razor_tag
- ensure: The basic property that the resource should be in.
          Valid values are `present`, `absent`.
- name: The tag name
- provider: The specific backend to use for this `razor_broker` resource. 
            You will seldom need to specify this --- Puppet will usually
            discover the appropriate provider for your platform.
            Available providers are:
- rest: REST provider for Razor broker
- rule: The tag rule (Array)


##Compatibility

This module has been tested with:
- Puppet 3.7.3 - Ruby 1.9.3 - Ubuntu 12.04
- Puppet 3.7.3 - Ruby 1.8.7 - CentOS 6.3

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

# == Class: razor::server
#
# Razor Provisioning: Server Setup
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::server inherits razor {
  # Validation
  if $::razor::database_password == undef {
    fail('database_password is a required parameter!')
  }
  validate_string($::razor::database_hostname, $::razor::database_name)
  validate_string($::razor::database_username, $::razor::database_password)
  validate_string($::razor::server_package_name, $::razor::server_package_version)
  validate_absolute_path($::razor::server_config_file)
  validate_absolute_path($::razor::repo_store)

  # Compatibility
  case $::osfamily {
    'debian': {
      case $::operatingsystem {
        'Ubuntu': {
          case $::lsbdistcodename {
            'lucid','maverick','natty','oneiric': {
              # Lucid - OK
            }
            'precise','quantal','raring','saucy': {
              # Precise - OK
            }
            'trusty','utopic','vivid': {
              # Trusty - NOT !!!
              fail("Ubuntu Trusty (>= 14.04) is not supported yet! ${::lsbdistcodename}")
            }
            default: {
              fail("Ubuntu < 10.04 and >= 14.04 is not supported: ${::lsbdistcodename}")
            }
          }
        }
        'Debian': {
          case $::lsbdistcodename {
            'squeeze','wheezy': {
              # Squeeze (6) - OK
              # Wheezy (7) - OK
            }
            default: {
              fail("Debian < 6 and > 8 is not supported: ${::lsbdistcodename}")
            }
          }
        }
        default: {
          fail("Operating System (debian) is not supported: ${::operatingsystem}")
        }
      }
    }
    'redhat': {
      case $::operatingsystem {
        'CentOS': {
          case $::operatingsystemmajrelease {
            '5': {
              # EL 5(x) - OK
              # EL 5.0 - 5.9 - OK
            }
            '6': {
              # EL 6(x) - OK
              # EL 6.0 - 6.5 - OK
            }
            '7': {
              # EL 7.1 - OK
            }
            default: {
              fail("CentOS/RHEL < 5 and > 7 is not supported: ${::operatingsystemmajrelease}")
            }
          }
        }
        'Fedora': {
          case $::operatingsystemmajrelease {
            '19': {
              fail('Fedora 19 is not supported')
            }
            '20': {
              # Fedora 20 - OK
            }
            default: {
              fail("Fedora < 20 and > 20 is not supported: ${::operatingsystemmajrelease}")
            }
          }
        }
        default: {
          fail("Operating System (Redhat) is not supported: ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Operating System Family is not supported: ${::osfamily}")
    }
  }

  # Installation

  # Requirement for version >=1.0.0 installation on Ubuntu 12.04
  # Package does not auto-require it!
  package { $::razor::torquebox_package_name:
    ensure => $::razor::torquebox_package_version,
  } ->

  package { $::razor::server_package_name:
    ensure => $::razor::server_package_version,
  } ~>  Exec['razor-migrate-database']

  # Configuration File
  ::razor::razor_yaml_setting{'production/database_url':
    ensure => present,
    target => $::razor::server_config_file,
    value  => "jdbc:postgresql://${::razor::database_hostname}/${::razor::database_name}?user=${::razor::database_username}&password=${::razor::database_password}"
  }
  ::razor::razor_yaml_setting{'all/repo_store_root':
    ensure => present,
    target => $::razor::server_config_file,
    value  => $::razor::repo_store
  }

  service { $::razor::server_service_name:
    ensure => 'running',
    enable => true,
  }

  # Setup the Database
  # File[$::razor::server_config_file] -> => not required?
  exec { 'razor-migrate-database':
    cwd         => '/opt/razor',
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/razor/bin', '/opt/razor-torquebox/jruby/bin'],
    command     => 'razor-admin -e production migrate-database',
    refreshonly => true,
    notify      => Service[$::razor::server_service_name],
  }

  Package[$::razor::server_package_name] -> Yaml_setting<| tag == 'razor-server' |> -> Service[$::razor::server_service_name]
  Yaml_setting<| tag == 'razor-server' |> ~> Exec['razor-migrate-database']
  Yaml_setting<| tag == 'razor-server' |> ~> Service[$::razor::server_service_name]
}

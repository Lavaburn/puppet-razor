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
  assert_type(String, $::razor::database_password) |$expected, $actual| {
    fail('database_password is a required parameter with enable_server = true.')
  }
  validate_absolute_path($::razor::server_config_path)
  validate_absolute_path($::razor::repo_store_path)

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
            'trusty','utopic','vivid', 'wily': {
              # Trusty - OK
            }
            'xenial', 'yakkety', 'zesty': {
              fail("Ubuntu Xenial (>= 16.04) is not supported yet! ${::lsbdistcodename}")
            }
            default: {
              fail("Ubuntu < 10.04 and >= 16.04 is not supported: ${::lsbdistcodename}")
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
  if ($::razor::enable_aio_support == false) {
    # Torquebox was auto-dependency < 1.0.0, but no longer by 1.3.0
    # From 1.4.0 (AIO packaging), it is included in the server package.
    package { $::razor::torquebox_package_name:
      ensure => $::razor::torquebox_package_version,
    } -> Package[$::razor::server_package_name]
  }

  package { $::razor::server_package_name:
    ensure => $::razor::server_package_version,
  } ~>  Exec['razor-migrate-database']

  # Configuration File
  ::razor::razor_yaml_setting{ 'production/database_url':
    ensure => 'present',
    value  => "jdbc:postgresql://${::razor::database_hostname}/${::razor::database_name}?user=${::razor::database_username}&password=${::razor::database_password}"
  }

  ::razor::razor_yaml_setting{ 'all/repo_store_root':
    ensure => 'present',
    value  => $::razor::repo_store_path
  }

  # Required configuration for database migration.
  # Configuration file is purged on downgrade from 1.5 to 1.3...
  ::razor::razor_yaml_setting{ 'all/match_nodes_on':
    ensure     => 'present',
    value      => $::razor::match_nodes_on,
    value_type => 'array',
  }

  # Service
  service { $::razor::server_service_name:
    ensure => 'running',
    enable => true,
  }

  # Setup the Database
  exec { 'razor-migrate-database':
    cwd         => $::razor::data_root_path,
    path        => [
      '/bin', '/sbin',
      '/usr/bin', '/usr/sbin',
      '/usr/local/bin', '/usr/local/sbin',
      $::razor::binary_path, $::razor::jruby_binary_path,
    ],
    command     => 'razor-admin -e production migrate-database',
    refreshonly => true,
    notify      => [
      Exec['razor-redeploy'],
      Service[$::razor::server_service_name]
    ],
  }

  # Redeploy application (required when upgrading)
  $source    = "source ${::razor::real_config_dir}/razor-torquebox.sh"
  $torquebox = "torquebox deploy ${::razor::data_root_path} --env=production"
  exec { 'razor-redeploy':
    cwd         => $::razor::data_root_path,
    path        => [
      '/bin', '/sbin',
      '/usr/bin', '/usr/sbin',
      '/usr/local/bin', '/usr/local/sbin',
      $::razor::torquebox_binary_path,
    ],
    command     => "bash -c '${source}; ${torquebox}'",
    refreshonly => true,
    notify      => Service[$::razor::server_service_name],
  }

  # Ordering
  Package[$::razor::server_package_name] -> Yaml_setting<| tag == 'razor-server' |> -> Service[$::razor::server_service_name]
  Yaml_setting<| tag == 'razor-server' |> ~> Exec['razor-migrate-database']
  Yaml_setting<| tag == 'razor-server' |> ~> Service[$::razor::server_service_name]
}

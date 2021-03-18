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
            'xenial', 'yakkety', 'zesty', 'artful': {
              # Xenial - OK
            }
            'bionic': {
              fail("Ubuntu Xenial (>= 18.04) is not supported yet! ${::lsbdistcodename}")
            }
            default: {
              fail("Ubuntu < 10.04 and >= 18.04 is not supported: ${::lsbdistcodename}")
            }
          }
        }
        'Debian': {
          case $::lsbdistcodename {
            'squeeze','wheezy','jessie','stretch': {
              # Squeeze (6) - OK
              # Wheezy (7) - OK
              # Jessie (8) - OK
              # Stretch (9) - OK
            }
            default: {
              fail("Debian < 6 and > 10 is not supported: ${::lsbdistcodename}")
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
  contain razor::server::install

  # Configuration
  contain razor::server::configure

  # Migration
  contain razor::server::migrate

  # Service
  service { $::razor::server_service_name:
    ensure => 'running',
    enable => true,
  }

  # Ordering
  Anchor['razor-server-postinstall'] -> Anchor['razor-server-preconfigure']
  Anchor['razor-server-postconfigure'] -> Anchor['razor-server-migrate']
  Anchor['razor-server-postconfigure'] -> Service[$::razor::server_service_name]

  if ($::razor::server_auto_deploy) {
    # Migrate Database after package install/upgrade
    Anchor['razor-server-postinstall'] ~> Anchor['razor-server-migrate']
    Anchor['razor-server-migrate'] ~> Service[$::razor::server_service_name]
  }
}

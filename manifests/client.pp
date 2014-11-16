# == Class: razor::client
#
# Razor Provisioning: Client Setup
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::client inherits razor {
  # Validation
  validate_string($::razor::client_package_name, $::razor::client_package_version)

  # Bugfixes for installing the gem
  if ($::operatingsystem == 'Ubuntu') {
    case $::lsbdistcodename {
      # Require Ruby >= 1.9.2
      'lucid','maverick','natty','oneiric','precise', 'quantal','raring','saucy': {
        $ruby_package_version = '1.9.1'
        $ruby_package_name = "ruby${ruby_package_version}"

				package { $ruby_package_name:
				  ensure    => 'installed',
				} -> Package[$::razor::client_package_name]

        Package[$ruby_package_name] ->
				exec { "set-ruby${ruby_package_version}-default":
			    command     => "/usr/bin/update-alternatives --set ruby /usr/bin/ruby${ruby_package_version}",
			    subscribe   => Package[$ruby_package_name],
			    refreshonly => true,
				} -> Package[$::razor::client_package_name]

        Package[$ruby_package_name] ->
				exec { "set-gem${ruby_package_version}-default":
          command     => "/usr/bin/update-alternatives --set gem /usr/bin/gem${ruby_package_version}",
          subscribe   => Package[$ruby_package_name],
          refreshonly => true,
        } -> Package[$::razor::client_package_name]
      }
    }
  }

  # Install the ruby gem
  package { $::razor::client_package_name:
    provider  => 'gem',
    ensure    => $::razor::client_package_version,
  }
}

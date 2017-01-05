# == Class: razor::db
#
# Razor Provisioning: Database Setup
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::db inherits razor {
  # Validation
  if $::razor::database_password == undef {
    fail('database_password is a required parameter!')
  }

  # Create User/Role/Database
  postgresql::server::db { $::razor::database_name:
    user     => $::razor::database_username,
    password => postgresql_password($::razor::database_username, $::razor::database_password),
  }
}

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
  validate_string($::razor::database_name, $::razor::database_username, $::razor::database_password)

  # Create User/Role/Database
  postgresql::server::db { $::razor::database_name:
    user     => $::razor::database_username,
    password => postgresql_password($::razor::database_username, $::razor::database_password),
  }
}

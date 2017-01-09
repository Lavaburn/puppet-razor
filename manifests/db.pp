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
  assert_type(String, $::razor::database_password) |$expected, $actual| {
    fail('database_password is a required parameter with enable_db = true.')
  }

  # Create User/Role/Database
  postgresql::server::db { $::razor::database_name:
    user     => $::razor::database_username,
    password => postgresql_password($::razor::database_username, $::razor::database_password),
  }
}

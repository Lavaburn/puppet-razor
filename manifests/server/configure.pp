# == Class: razor::server::configure
#
# Razor Provisioning: Server Setup - Configuration
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::server::configure inherits razor {
  anchor { 'razor-server-preconfigure': }
  anchor { 'razor-server-postconfigure': }

  # Database URL
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{ 'production/database_url':
    ensure => 'present',
    value  => "jdbc:postgresql://${::razor::database_hostname}/${::razor::database_name}?user=${::razor::database_username}&password=${::razor::database_password}"
  } -> Anchor['razor-server-postconfigure']

  # Path where microkernel and OS images are stored
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{ 'all/repo_store_root':
    ensure => 'present',
    value  => $::razor::repo_store_path
  } -> Anchor['razor-server-postconfigure']

  # Paths for brokers
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{'all/broker_path':
    ensure => 'present',
    value  => join(concat($::razor::server_broker_paths, 'brokers'), ':')
  } -> Anchor['razor-server-postconfigure']

  # Paths for hooks
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{'all/hook_path':
    ensure => 'present',
    value  => join(concat($::razor::server_hook_paths, 'hooks'), ':')
  } -> Anchor['razor-server-postconfigure']

  # Paths for tasks
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{'all/task_path':
    ensure => 'present',
    value  => join(concat($::razor::server_task_paths, 'tasks'), ':')
  } -> Anchor['razor-server-postconfigure']

  # Array of unique identifiers for the node
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{ 'all/match_nodes_on':
    ensure     => 'present',
    value      => $::razor::match_nodes_on,
    value_type => 'array',
  } -> Anchor['razor-server-postconfigure']

  # Allow localhost API calls (> 1.3.0)
  Anchor['razor-server-preconfigure'] ->
  ::razor::razor_yaml_setting{ 'all/auth/allow_localhost':
    ensure => 'present',
    value  => "true",# lint:ignore:quoted_booleans lint:ignore:double_quoted_strings
  }
}

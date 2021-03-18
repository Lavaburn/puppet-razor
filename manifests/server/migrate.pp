# == Class: razor::server::migrate
#
# Razor Provisioning: Server Setup - Database Migration / Torquebox redeploy
#
# This is a private class. Only use the 'razor' class.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class razor::server::migrate inherits razor {
  anchor { 'razor-server-migrate': }

  # Setup the Database
  Anchor['razor-server-migrate'] ~>
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
  } ~> Exec['razor-redeploy']

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
  } ~> Service[$::razor::server_service_name]
}

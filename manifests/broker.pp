# == Definition: razor::broker
#
# Razor Provisioning: Broker
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::broker (
  String $module    = 'razor',
  String $directory = 'brokers',
  String $root      = "${::razor::data_root_path}/brokers",
) {
  # Validation
  validate_absolute_path($root)

  # Create directory
  Package[$::razor::server_package_name]
  ->
  file { "${root}/${name}.broker":
    ensure  => 'directory',
    source  => "puppet:///modules/${module}/${directory}/${name}.broker",
    recurse => true,
  }
}

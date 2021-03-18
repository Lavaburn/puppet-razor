# == Definition: razor::broker
#
# Razor Provisioning: Broker
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::broker (
  String $module           = 'razor',
  String $directory        = 'brokers',
  String $root             = "${::razor::data_root_path}/brokers",
  Optional[String] $source = undef,
) {
  # Validation
  validate_absolute_path($root)

  $source_ = $source ? {
    undef   => "puppet:///modules/${module}/${directory}/${name}.broker",
    default => $source,
  }

  # Create directory
  Package[$::razor::server_package_name]
  ->
  file { "${root}/${name}.broker":
    ensure  => 'directory',
    source  => $source_,
    recurse => true,
  }
}

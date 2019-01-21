# == Definition: razor::hook
#
# Razor Provisioning: Hook
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::hook (
  String $module    = 'razor',
  String $directory = 'hooks',
  String $root      = "${::razor::data_root_path}/hooks",
) {
  # Validation
  validate_absolute_path($root)

  # Create directory
  Package[$::razor::server_package_name]
  ->
  file { "${root}/${name}.hook":
    ensure  => 'directory',
    source  => "puppet:///modules/${module}/${directory}/${name}.hook",
    recurse => true,
  }
}

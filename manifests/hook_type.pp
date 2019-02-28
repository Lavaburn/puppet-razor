# == Definition: razor::hook_type
#
# Razor Provisioning: Hook Type
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
# Henrique Lindgren <henriquelindgren@gmail.com>
#
define razor::hook_type (
  $module    = 'razor',
  $directory = 'hooks',
  $root      = "${::razor::data_root_path}/hooks",
  $source    = undef,
) {
  # Validation
  validate_absolute_path($root)

  $source_ = $source ? {
    undef   => "puppet:///modules/${module}/${directory}/${name}.hook",
    default => $source,
  }

  # Create directory
  Package[$::razor::server_package_name]
  ->
  file { "${root}/${name}.hook":
    ensure  => 'directory',
    source  => $source_,
    recurse => true,
  }
}

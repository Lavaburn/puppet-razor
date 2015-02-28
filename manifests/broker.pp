# == Definition: razor::broker
#
# Razor Provisioning: Broker
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::broker (
  $root = '/opt/razor/brokers', # TODO DEFAULT FROM MAIN CLASS ??
) {
  # Validation
  validate_absolute_path($root)

  # Create directory
  file { "${root}/${name}.broker":
    ensure  => 'directory',
    source  => "puppet:///modules/razor/${name}.broker",
    recurse => true,
  }

  # TODO API Call ...
}

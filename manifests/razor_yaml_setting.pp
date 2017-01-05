# == Define: razor::razor_yaml_setting
#
# Helper define for working with yaml configurations settings.
#
# === Authors
#
# Jeremy Custenborder <jcustenborder@gmail.com>
#
define razor::razor_yaml_setting (
  String $target,
  Variant[Undef, String] $value     = undef,
  Enum['present', 'absent'] $ensure = 'present',
  String $export_tag                = 'razor-server'
) {
  yaml_setting { $name:
    ensure => $ensure,
    key    => $name,
    target => $target,
    value  => $value,
    tag    => $export_tag,
  }
}

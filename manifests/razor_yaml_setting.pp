# == Define: razor::razor_yaml_setting
#
# Helper define for working with yaml configurations settings.
#
# === Authors
#
# Jeremy Custenborder <jcustenborder@gmail.com>
#
define razor::razor_yaml_setting (
  $target,
  $value      = undef,
  $ensure     = 'present',
  $export_tag = 'razor-server'
) {
  validate_re($ensure, ['present', 'absent'])

  yaml_setting { $name:
    ensure => $ensure,
    key    => $name,
    target => $target,
    value  => $value,
    tag    => $export_tag,
  }
}

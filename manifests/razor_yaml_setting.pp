# == Define: razor::razor_yaml_setting
#
# Helper define for working with yaml configurations settings.
#
# === Authors
#
# Jeremy Custenborder <jcustenborder@gmail.com>
#
define razor::razor_yaml_setting($ensure, $target, $value=undef){
  case $ensure{
    'absent':{
      yaml_setting{$name:
        ensure => absent,
        key    => $name,
        target => $target,
        tag    => 'razor-server'
      }
    }
    'present':{
      yaml_setting{$name:
        ensure => present,
        key    => $name,
        target => $target,
        value  => $value,
        tag    => 'razor-server'
      }
    }
  }
}
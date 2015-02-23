# == Definition: razor::task
#
# Razor Provisioning: Task
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::task (
  $root = '/opt/razor/tasks', # TODO DEFAULT FROM MAIN CLASS ??
) {
  # Validation
  validate_absolute_path($root)
  
  # Create directory
  file { "${root}/${name}.task":
    ensure  => 'directory',
    source  => "puppet:///modules/razor/${name}.task",
    recurse => true,
  }
  
  # TODO API Call ...
}

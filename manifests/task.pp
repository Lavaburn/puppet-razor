# == Definition: razor::task
#
# Razor Provisioning: Task
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define razor::task (
  String $module    = 'razor',
  String $directory = 'tasks',
  String $root      = "${::razor::data_dir}/tasks",
) {
  # Validation
  validate_absolute_path($root)

  # Create directory
  file { "${root}/${name}.task":
    ensure  => 'directory',
    source  => "puppet:///modules/${module}/${directory}/${name}.task",
    recurse => true,
  }

  # TODO API Call ...
}

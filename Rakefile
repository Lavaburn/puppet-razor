# Gems: Rake tasks
require 'puppetlabs_spec_helper/rake_tasks'
require 'ra10ke'

# These two gems aren't always present (for instance on Travis with --without development).
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

# Directories that don't need to be checked (Lint/Syntax)
exclude_dirs = [
	"spec/**/*",
  "examples/**/*",
  "pkg/**/*",
  "test/**/*",
]

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_dirs
  config.disable_checks = [
    "80chars", "140chars", 
    "variable_is_lowercase", "class_inherits_from_params_class",
    "relative_classname_inclusion", "trailing_comma",
    "variable_contains_upcase", "version_comparison",
    "variable_is_lowercase", "arrow_on_right_operand_line"
  ] # TODO

  config.with_context = true
  config.relative = true
  #  config.log_format = '%{filename} - %{message}'
  #  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
end

# Group tests
desc "Run syntax, lint, and spec tests."
task :test => [
	:syntax,
#	'r10k:syntax',        # Seems to be broken in Ruby 2.5.7 ?
	:lint,
	:metadata_lint,
	:spec,
]

# Copied from puppet-blacksmith. Not using the Git push !!!
desc "Release the Puppet module, doing a clean, build, tag, push and bump_commit."
task :release => ['module:clean', 'build', 'module:tag', 'module:push', 'module:bump_commit'] do
  puts "Don't forget to push your tags to remote git repo(s)"
end

# r10k:syntax
Ra10ke::RakeTask.new

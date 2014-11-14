# Required gems
require 'rubygems'
require 'bundler/setup'
require 'hiera'

# Gems: Rake tasks
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These gems aren't always present
begin
	#On Travis with --without development
	require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end


# Directories that don't need to be checked (Lint/Syntax)
exclude_paths = [
	"spec/**/*",
  "examples/**/*",
]


# Puppet Lint config 
PuppetLint.configuration.relative = true
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.with_context = true

PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

PuppetLint.configuration.send("disable_80chars") 
PuppetLint.configuration.send("class_inherits_from_params_class") 
           # 'class_parameter_defaults', ''

PuppetLint.configuration.ignore_paths = exclude_paths # TODO - Does not work !!
PuppetSyntax.exclude_paths = exclude_paths


# Extra Tasks
desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
	t.pattern = 'spec/acceptance'
end

desc "Run syntax, lint, and spec tests."
task :test => [
	:syntax,
# TODO - Disabled due to issue - 	:lint,
	:metadata,
	:spec,
]
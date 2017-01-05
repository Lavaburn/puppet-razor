require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

# Directories that don't need to be checked (Lint/Syntax)
exclude_paths = [
	"spec/**/*",
  "examples/**/*",
  "pkg/**/*",
  "test/**/*",
]


# Settings for syntax checker
PuppetSyntax.exclude_paths = exclude_paths


# Overwrite default lint task
Rake::Task[:lint].clear
# Puppet Lint config
PuppetLint::RakeTask.new :lint do |config|
  #config.relative = true           # BUG in 1.1.0 - does not work ?  
  config.with_context = true  
  config.fail_on_warnings = false
  
  config.fix = false                # TODO does not actually fix anything
  
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  
  config.disable_checks = [ "80chars", "class_inherits_from_params_class" ] # class_parameter_defaults
    
  config.ignore_paths = exclude_paths
end


# Extra Tasks
desc "Check Puppetfile syntax"
task :puppetfile do
  sh "env PUPPETFILE_DIR=. r10k -v INFO puppetfile check"
end

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
	t.pattern = 'spec/acceptance'
end

desc "Run syntax, lint, and spec tests."
task :test => [
	:syntax,
	:puppetfile,
	:lint,
	:metadata_lint,
	:spec,
]

# Copied from puppet-blacksmith. Not using the Git push !!!
desc "Release the Puppet module, doing a clean, build, tag, push and bump_commit."
task :release => ['module:clean', 'build', 'module:tag', 'module:push', 'module:bump_commit'] do
  puts "Don't forget to push your tags to remote git repo(s)"
end
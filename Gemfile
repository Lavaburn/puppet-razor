source "https://rubygems.org"

group :test do	
	gem "cri", '~> 2.9.1' if RUBY_VERSION < '2.3.0'
	
	gem 'facterdb', '~> 0.3.12'
	
	gem "metadata-json-lint"
	
	gem "parallel_tests"
	
	gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.6.0'
	
	if RUBY_VERSION < '2.4.0'	
		gem "puppetlabs_spec_helper", '~> 2.16.0'
	else	
		gem "puppetlabs_spec_helper"
	end
	
	gem "r10k"
	gem "ra10ke"
	
	gem 'rspec-puppet-facts'
	gem "rspec-puppet-utils"
end

group :integration_test do
  # Ruby 2.4.5
  gem 'beaker-puppet_install_helper'
  gem 'beaker-rspec'  
  gem 'beaker-vagrant'
  gem 'vagrant-wrapper'

  gem 'infrataster'
end
		  
group :development do	
	gem "guard-rake" if RUBY_VERSION >= '2.2.5'
	
	gem "puppet-blacksmith"
	
    gem "travis"
    gem "travis-lint"
    
	gem 'rspec-stackprof'
end

source "https://rubygems.org"

group :test do	
	if RUBY_VERSION < '2.3.0'	
		gem "cri", '~> 2.9.1'
	end
	
	gem 'facterdb', '~> 0.3.12'
	
	gem "metadata-json-lint"
	
	gem "parallel_tests"
	
	gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.3.2'
	gem "puppetlabs_spec_helper"
	
	gem "r10k"		
	gem "ra10ke"
	
	gem 'rspec-puppet-facts'
	gem "rspec-puppet-utils"
end

group :integration_test do		
	gem 'beaker', '~> 3.13.0'
	gem 'beaker-puppet_install_helper', '~> 0.7.1'
	gem 'beaker-rspec'
		
	gem 'infrataster'

	gem "nokogiri", '~> 1.6.8' if RUBY_VERSION < '2.2.2'
	gem 'rack', '~> 1.6.8' if RUBY_VERSION < '2.2.2'
	gem 'rack-test', '~> 0.7.0' if RUBY_VERSION < '2.2.2'

	gem "vagrant-wrapper"
end
		  
group :development do	
	gem "guard-rake" if RUBY_VERSION >= '2.2.5'
	
	gem "puppet-blacksmith"
	
    gem "travis"
    gem "travis-lint"
end

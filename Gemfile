source "https://rubygems.org"

group :test do
	gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.3.2'
	gem "puppetlabs_spec_helper"
	gem "metadata-json-lint"
	gem "r10k"	
end

group :integration_test do			  	  
	gem "beaker-rspec"
	gem "vagrant-wrapper"
	gem 'beaker-puppet_install_helper'
end
		  
group :development do	
	gem "puppet-blacksmith"
	gem "guard-rake"
	
    gem "travis"
    gem "travis-lint"
end

source "https://rubygems.org"

group :test do
	gem "rake"

	gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.7.0'
	gem "rspec-puppet"	#, :git => 'https://github.com/rodjek/rspec-puppet.git'
	gem "puppetlabs_spec_helper", :git => 'https://github.com/puppetlabs/puppetlabs_spec_helper.git'
end

group :development do
	# gem "travis"
	# gem "travis-lint"
	
	gem "beaker"
	gem "beaker-rspec"
	gem "beaker-librarian"
	gem "vagrant-wrapper"
	
	gem "puppet-blacksmith"
end
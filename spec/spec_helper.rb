require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
RSpec.configure do |c|
  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
  
  c.before do
    # avoid "Only root can execute commands as other users"
    # required by Postgres dependency
    Puppet.features.stubs(:root? => true)
  end
end
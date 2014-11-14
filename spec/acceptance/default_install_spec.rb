require 'spec_helper_acceptance'

describe 'example class' do
	describe 'running puppet code' do
    	it 'should work with no errors' do
      		pp = <<-EOS
        		class { 'example': }
      		EOS

      		# Run it twice and test for idempotency
      		apply_manifest(pp, :catch_failures => true)
      		
      		expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      	end
    end
end
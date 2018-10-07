shared_examples 'a running razor server' do |port, microkernel, version_expected|  
  describe port(port) do
    it { should be_listening }
  end
     
  describe service('razor-server') do
    it { should be_running }
  end
      
  describe file("#{microkernel}/initrd0.img") do
    it { should be_file }
  end
       
  describe command("cd #{microkernel}; sha256sum -c SHA256SUM") do
    its(:exit_status) { should eq(0) }
  end
        
  describe command("/opt/puppetlabs/puppet/bin/razor -u http://localhost:#{port}/api -v") do
    its(:exit_status) { should eq(0) }
    its(:stdout) { should contain("Razor Server version: #{version_expected}") }
  end

  it 'custom fact should show the correct version' do
    manifest = <<-EOS  
      if ($::razorserver['version'] != '#{version_expected}') {
        fail("Custom fact reports version: ${::razorserver['version']}. Expected: #{version_expected}") 
      }
    EOS
    
    result = apply_manifests(agents, manifest, { :catch_changes => true })
    expect(result.exit_code).to eq(0)
  end
end

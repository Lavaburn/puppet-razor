shared_examples 'a valid microkernel image' do
  pkg_dir = '/opt/razor-el-mk/pkg/'
    
  describe file(pkg_dir), :if => (fact('operatingsystem') == 'CentOS' and fact('operatingsystemmajrelease') == '7') do
    it { should be_directory }
  end
  
  describe file("#{pkg_dir}/microkernel.tar"), :if => (fact('operatingsystem') == 'CentOS' and fact('operatingsystemmajrelease') == '7') do
    it { should be_file }
  end
       
  describe command("tar -xvpf #{pkg_dir}/microkernel.tar -C /tmp"), :if => (fact('operatingsystem') == 'CentOS' and fact('operatingsystemmajrelease') == '7') do
    its(:exit_status) { should eq(0) }
  end
 
  describe command("cd /tmp/microkernel; sha256sum -c SHA256SUM"), :if => (fact('operatingsystem') == 'CentOS' and fact('operatingsystemmajrelease') == '7') do
    its(:exit_status) { should eq(0) }
  end
end

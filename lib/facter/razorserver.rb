# razorserver_version.rb:
# This script will get the current version of Razor Server (if running)
#
# Copyright (c) 2017 Nicolas Truyens <nicolas@truyens.com>

if File.exist?("/usr/local/bin/razor")
  Facter.add('razorserver') do
    confine :kernel => :Linux
  
    setcode do
      begin
        # Check which ports are in use
        port8150_s = Facter::Core::Execution.exec('/bin/netstat -ln | /bin/grep 8150 | /usr/bin/wc -l')
        port8150 = port8150_s.gsub(/\s+/, '').to_i
  
        if port8150 > 0
          razor = Facter::Core::Execution.exec('/usr/local/bin/razor -u http://localhost:8150/api -v | /bin/grep "Razor Server version"')
        else
          port8080_s = Facter::Core::Execution.exec('/bin/netstat -ln | /bin/grep 8080 | /usr/bin/wc -l')
          port8080 = port8080_s.gsub(/\s+/, '').to_i
  
          razor = if port8080 > 0
                    Facter::Core::Execution.exec('/usr/local/bin/razor -u http://localhost:8080/api -v | /bin/grep "Razor Server version"')
                  else
                    ''
                  end
        end
  
        version = razor.match(/Razor Server version: (.*)/)[1] if razor =~ /Razor Server version: (.*)/
      rescue
        puts "Error while fetching Razor Server version: #{errors.inspect} "
        version = nil
      end
  
      # Create Facts
      razorserver_facts = {}
  
      razorserver_facts[:version] = version if version
  
      razorserver_facts
    end
  end
end

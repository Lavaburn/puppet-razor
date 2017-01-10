# razorserver_version.rb:
# This script will get the current version of Razor Server (if running)
#
# Copyright (c) 2017 Nicolas Truyens <nicolas@truyens.com>

require 'facter'

if Facter.value(:kernel) == "Linux" 
  Facter.add('razorserver') do
    confine :kernel => :Linux
  
    begin                
      # Check which ports are in use 
      port8150_s = `/bin/netstat -ln | /bin/grep 8150 | /usr/bin/wc -l`
      port8150 = port8150_s.gsub(/\s+/, "").to_i
      
      if port8150 > 0
        razor = `/usr/local/bin/razor -u http://localhost:8150/api -v | /bin/grep "Razor Server version"`
      else
        port8080_s = `/bin/netstat -ln | /bin/grep 8080 | /usr/bin/wc -l`
        port8080 = port8080_s.gsub(/\s+/, "").to_i
        
        if port8080 > 0
          razor = `/usr/local/bin/razor -u http://localhost:8080/api -v | /bin/grep "Razor Server version"`
        else
          razor = ""
        end          
      end

      if razor =~ /Razor Server version: (.*)/          
        matchdata = razor.match(/Razor Server version: (.*)/)
        version = matchdata[1]
      else
        version = nil
      end
    rescue
      puts "Error while fetching Razor Server version: #{errors.inspect} "
      version = nil
    end
    
    # Create Facts
    razorserver_facts = {}
      
    if version then    
      razorserver_facts[:version] = version
    end
    
    setcode { razorserver_facts }
  end
end
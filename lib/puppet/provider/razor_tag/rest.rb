require File.join(File.dirname(__FILE__), '..', 'razor_rest')

Puppet::Type.type(:razor_tag).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Razor tag"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :absent      
      delete_tag
      return 
    end
    
    if @property_flush[:ensure] == :present      
      create_tag
      return 
    end
    
    update_tag
  end  
  
  def self.instances
    # TODO Need credentials from puppet first  ???
    get_objects(:tags).collect do |object|
      new(object)
    end    
  end
  
  # TODO TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    

    {
      :name   => responseJson['name'],
      :rule   => responseJson['rule'],
      :ensure => :present
    }
  end
  
  def self.get_tag(name)
    # TODO
    ip = '192.168.50.13'
    port = '8080'
    url = "http://#{ip}:#{port}/api/collections/tags/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_tag       
    resourceHash = {                    
      :name => resource[:name],
      :rule => resource[:rule]
    }      
    post_command('create-tag', resourceHash)
  end
  
  def update_tag            
    # Rule
    # TODO TEST RULES EQUAL? => not really required as it is the only attribute    
      #.each_with_index {|item, index| hash[item] = index } 
      #if @property_hash[:rule] != resource[:rule]       => Doens't work anymore ??
    
    resourceHash = {                    
      :name => resource[:name],
      :rule => resource[:rule]
    }
    post_command('update-tag-rule', resourceHash)
    
    # Update the current info
    @property_hash = self.class.get_tag(resource[:name])
  end  
  
  def delete_tag
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-tag', resourceHash)    
  end    
end
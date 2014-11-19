require File.join(File.dirname(__FILE__), '..', 'razor_rest')

Puppet::Type.type(:razor_policy).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Razor policy"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :absent      
      delete_policy
      return 
    end
    
    if @property_flush[:ensure] == :present      
      create_policy
      return 
    end
    
    update_policy
  end  
  
  def self.instances
    # TODO Need credentials from puppet first  ???
    get_objects(:policies).collect do |object|
      new(object)
    end    
  end
  
  # TODO TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    
    
    tags = responseJson['tags'].collect do |tag| 
      tag['name']
    end

    {
      :name           => responseJson['name'],        
      :repo           => responseJson['repo']['name'],# Repo returns the real object reference, rather than just the name
      :task           => responseJson['task']['name'],# Task returns the real object reference, rather than just the name
      :broker         => responseJson['broker']['name'],# Broker returns the real object reference, rather than just the name
      :hostname       => responseJson['configuration']['hostname_pattern'],
      :root_password  => responseJson['configuration']['root_password'],
      :max_count      => responseJson['max_count'],
      :node_metadata  => (responseJson['node_metadata']==nil)?{}:responseJson['node_metadata'],
      :tags           => tags,
      :ensure         => :present      
    }
    # TODO responseJson['enabled']
  end
  
  def self.get_policy(name)
    # TODO
    ip = '192.168.50.13'
    port = '8080'
    url = "http://#{ip}:#{port}/api/collections/policies/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_policy
    resourceHash = {                    
      :name           => resource[:name],        
      :repo           => resource[:repo],
      :task           => resource[:task],
      :broker         => resource[:broker],
      :hostname       => resource[:hostname],
      :root_password  => resource[:root_password],
      :max_count      => resource[:max_count].to_i,   # TODO check string vs numeric. Puppet only knows strings
      :node_metadata  => resource[:node_metadata],
      :tags           => resource[:tags],
    }      
    #TODO   :before|after  => resource[:before|after],
    
    post_command('create-policy', resourceHash)
  end
  
  def update_policy 
    # TODO Add param: enabled
      # "enable-policy" / "disable-policy"
    
    # TODO Compare Tags
      # "add-policy-tag" / "remove-policy-tag"
    
    # TODO Compare Max-count
      # "modify-policy-max-count"
    
    # TODO ELSE - DELETE/CREATE
    
    # BEFORE/AFTER Can't be tracked.. Do not use this?
      # "move-policy"
        
#    Puppet.debug("Calling REST for x")    
#    resourceHash = {                    
#      :name => resource[:name],
#      :x => resource[:x]
#    }
#    post_command('x', resourceHash)
    
    # Update the current info
    
    @property_hash = self.class.get_policy(resource[:name])
  end  
  
  def delete_policy
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-policy', resourceHash)    
  end    
end

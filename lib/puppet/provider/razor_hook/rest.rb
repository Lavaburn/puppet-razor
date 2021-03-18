require File.join(File.dirname(__FILE__), '..', 'razor_rest')

Puppet::Type.type(:razor_hook).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Razor hook"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :absent      
      delete_hook
      return 
    end
    
    if @property_flush[:ensure] == :present      
      create_hook
      return 
    end

    unless resource.mutable_configuration?
      update_hook
    end
  end  

  def self.instances
    get_objects(:hooks).collect do |object|
      new(object)
    end
  end
  
  # TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    

    {
      :name           => responseJson['name'],
      :hook_type      => responseJson['hook_type'],
      :configuration  => responseJson['configuration'],
      :ensure         => :present
    }
  end
  
  def self.get_hook(name)
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/hooks/#{name}" 
    
    get_object(name, url)
  end
  
  private  
  def create_hook  
    resourceHash = {                    
      :name          => resource[:name],
      :hook_type     => resource['hook_type'],
      :configuration => resource['configuration'] || {},
    }
    post_command('create-hook', resourceHash)
  end
  
  def update_hook
    # Hook does not provide an update function
    Puppet.warning("Razor REST API does not provide an update function for the hook.")
    Puppet.warning("Will attempt a delete and create.")
    
    delete_hook
    create_hook
  end  
  
  def delete_hook
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-hook', resourceHash)    
  end    
end

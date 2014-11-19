require File.join(File.dirname(__FILE__), '..', 'razor_rest')

Puppet::Type.type(:razor_broker).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Razor broker"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :absent      
      delete_broker
      return 
    end
    
    if @property_flush[:ensure] == :present      
      create_broker
      return 
    end
    
    update_broker
  end  

  def self.instances
    # TODO Need credentials from puppet first  ???
    get_objects(:brokers).collect do |object|
      new(object)
    end
  end
  
  # TODO TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    

    {
      :name           => responseJson['name'],
      :broker_type    => responseJson['broker-type'],
      :configuration  => responseJson['configuration'],
      :ensure         => :present
    }
  end
  
  def self.get_broker(name)
    # TODO
    ip = '192.168.50.13'
    port = '8080'
    url = "http://#{ip}:#{port}/api/collections/brokers/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_broker  
    resourceHash = {                    
      :name           => resource[:name],
      'broker-type'   => resource['broker_type'],
      :configuration  => resource['configuration'],
    }      
    post_command('create-broker', resourceHash)
  end
  
  def update_broker
    # Broker does not provide an update function
    Puppet.warning("Razor REST API does not provide an update function for the broker.")
    Puppet.warning("Will attempt a delete and create, which will only work if the broker is not used by a policy.")
    
    delete_broker
    create_broker
  end  
  
  def delete_broker
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-broker', resourceHash)    
  end    
end

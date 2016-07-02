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
    get_objects(:brokers).collect do |object|
      new(object)
    end
  end
  
  # TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    

    {
      :name           => responseJson['name'],
      :broker_type    => responseJson['broker_type'],
      :configuration  => responseJson['configuration'],
      :ensure         => :present
    }
  end
  
  def self.get_broker(name)
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/brokers/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_broker  
    resourceHash = {                    
      :name           => resource[:name],
      'broker_type'   => resource['broker_type'],
      :configuration  => resource['configuration'],
    }      
    post_command('create-broker', resourceHash)
  end
  
  def update_broker
    current_state = self.class.get_broker(resource[:name])
    updated = false
    
    # Configuration
    if current_state[:configuration] != @property_hash[:configuration]
      current = current_state[:configuration]
      expected = @property_hash[:configuration]
      
      # Update or Delete
      current.select { |k1, v1|
        found = false
        
        expected.select { |k2, v2|
          if k1 == k2
            if v1 != v2
              resourceHash = {                    
                :broker => resource[:name],
                :key    => k1,
                :value  => v2,
              }
              post_command('update-broker-configuration', resourceHash)
            end
                        
            found = true
          end          
        }
        
        if !found
          resourceHash = {                    
            :broker => resource[:name],
            :key    => k1,
            :clear  => true,
          }
          post_command('update-broker-configuration', resourceHash)
        end
      }

      # Add
      expected.select { |k1, v1|
        found = false 
        
        current.select { |k2, v2|
          if k1 == k2
            found = true
          end
        }
        
        if !found
          resourceHash = {                    
            :broker => resource[:name],
            :key    => k1,
            :value  => v1,
          }
          post_command('update-broker-configuration', resourceHash)
         end
      }
      
      updated = true
    end
    
    if (!updated)
      # Broker does not provide an update function
      Puppet.warning("Razor REST API only provides an update function for the broker configuration.")
      Puppet.warning("Will attempt a delete and create, which will only work if the broker is not used by a policy.")
      
      delete_broker
      create_broker
    end
            
    # Update the current info    
    @property_hash = self.class.get_broker(resource[:name])
  end  
  
  def delete_broker
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-broker', resourceHash)    
  end    
end

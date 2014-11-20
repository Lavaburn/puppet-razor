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
    get_objects(:policies).collect do |object|
      new(object)
    end    
  end
  
  # TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)    
    
    tags = responseJson['tags'].collect do |tag| 
      tag['name']
    end
        
    # Repo returns the real object reference, rather than just the name
    # Task returns the real object reference, rather than just the name
    # Broker returns the real object reference, rather than just the name
    {
      :name           => responseJson['name'],        
      :repo           => responseJson['repo']['name'],
      :task           => responseJson['task']['name'],
      :broker         => responseJson['broker']['name'],
      :hostname       => responseJson['configuration']['hostname_pattern'],
      :root_password  => responseJson['configuration']['root_password'],
      :max_count      => (responseJson['max_count']==nil)?nil:responseJson['max_count'].to_s,        
      :node_metadata  => (responseJson['node_metadata']==nil)?{}:responseJson['node_metadata'],
      :tags           => tags,
      :enabled        => responseJson['enabled']?(:true):(:false),
      :ensure         => :present      
    }
  end
  
  def self.get_policy(name)
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/policies/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_policy
    # The fun with - and _ just doesn't stop. Razor => fix your API! Ruby does not like - in variables !!
    resourceHash = {                    
      :name           => resource[:name],        
      :repo           => resource[:repo],
      :task           => resource[:task],
      :broker         => resource[:broker],
      :hostname       => resource[:hostname],
      :root_password  => resource[:root_password],
      'max-count'     => (resource[:max_count]==nil)?nil:resource[:max_count].to_i,
      :node_metadata  => resource[:node_metadata],
      :tags           => resource[:tags],
    }
    
    if (resource[:before_policy] != nil)
      resourceHash[:before] = resource[:before_policy]
    end
    
    if (resource[:after_policy] != nil)
      resourceHash[:after] = resource[:after_policy]
    end
    
    post_command('create-policy', resourceHash)
    
    if resource[:enabled] == :false
      change_status
    end    
  end
  
  def update_policy 
    current_state = self.class.get_policy(resource[:name])
    updated = false
    
    # Tags
    add_tags = @property_hash[:tags] - current_state[:tags]
    add_tags.each do |tag|
      resourceHash = {                    
         :name => resource[:name],
         :tag  => tag
      }
      post_command('add-policy-tag', resourceHash)
      updated = true
    end
      
    remove_tags = current_state[:tags] - @property_hash[:tags]
    remove_tags.each do |tag| 
      resourceHash = {                    
         :name => resource[:name],
         :tag  => tag
      }
      post_command('remove-policy-tag', resourceHash)
      updated = true
    end   

    # Enable/Disable
    if current_state[:enabled] != @property_hash[:enabled]
      change_status
    end
    
    if current_state[:max_count] != @property_hash[:max_count]
      # More magic with - and _
      resourceHash = {                    
        :name       => resource[:name],
        "max-count"  => @property_hash[:max_count],
      }
      post_command('modify-policy-max-count', resourceHash)
      updated = true
    end
    
    if (!updated)
      # Policy does not provide a general update function
      Puppet.warning("Razor REST API does not provide a general update function for the policy.")
      Puppet.warning("Will attempt a delete and create.")
      
      delete_policy
      create_policy
    end
    
    # BEFORE/AFTER Can't be tracked.. Do not use this?
      # "move-policy"
        
    # Update the current info    
    @property_hash = self.class.get_policy(resource[:name])
  end  
  
  def delete_policy
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-policy', resourceHash)    
  end    
  
  def change_status
    resourceHash = {                    
      :name => resource[:name],
    }
    if @property_hash[:enabled] == :true
      post_command('enable-policy', resourceHash)
    end
    if @property_hash[:enabled] == :false
      post_command('disable-policy', resourceHash)
    end    
  end
  
  # OVERWRITING mk_resource_methods
#  def max_count
#    @property_hash[:max_count]
#  end
#  
#  def max_count=(value)
#    @property_hash[:max_count] = value
#  end
end

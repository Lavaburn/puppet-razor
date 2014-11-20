require File.join(File.dirname(__FILE__), '..', 'razor_rest')

Puppet::Type.type(:razor_repo).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Razor repo"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :absent      
      delete_repo
      return 
    end
    
    if @property_flush[:ensure] == :present      
      create_repo
      return 
    end
    
    update_repo
  end  

  def self.instances
    get_objects(:repos).collect do |object|
      new(object)
    end
  end
  
  # TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)  
      
    # Task returns the real object reference, rather than just the name
    {
      :name     => responseJson['name'],
      :iso_url  => responseJson['iso_url'],
      :url      => responseJson['url'],
      :task     => responseJson['task']['name'],
      :ensure   => :present
    }
  end
  
  def self.get_repo(name)
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/repos/#{name}" 
    
    get_object(name, url)    
  end
  
  private  
  def create_repo    
    if (resource[:iso_url] != nil)
      # To create: iso-url / after that Razor magically makes it a iso_url...
      resourceHash = {                    
        :name         => resource[:name],
        'iso-url'     => resource[:iso_url],
        :task         => resource[:task],
      }
    else
      resourceHash = {                    
        :name   => resource[:name],
        'url'   => resource[:url],
        :task   => resource[:task],
      }
    end

    post_command('create-repo', resourceHash)
  end
  
  def update_repo
    # Repo does not provide an update function
    Puppet.warning("Razor REST API does not provide an update function for the repo.")
    Puppet.warning("Will attempt a delete and create, which will only work if the repo is not used by a policy.")
    
    delete_repo
    create_repo
  end  
  
  def delete_repo
    resourceHash = {                    
      :name => resource[:name],
    }
    post_command('delete-repo', resourceHash)    
  end    
end

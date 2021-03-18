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
    get_objects(:tags).collect do |object|
      new(object)
    end
  end

  # TYPE SPECIFIC
  def self.get_object(name, url)
    responseJson = get_json_from_url(url)

    {
      :name   => responseJson['name'],
      :rule   => responseJson['rule'],
      :ensure => :present
    }
  end

  def self.get_tag(name)
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/tags/#{name}"

    get_object(name, url)
  end

  private
  def create_tag
    resourceHash = {
      :name => resource[:name],
      :rule => fixSpaces(resource[:rule])
    }
    post_command('create-tag', resourceHash)
  end

  def update_tag
    resourceHash = {
      :name  => resource[:name],
      :rule  => fixSpaces(resource[:rule]),
      :force => true
    }
    Puppet.debug("update-tag-rule #{resourceHash.inspect} => JSON #{resourceHash.to_json}")
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
  
  def fixSpaces(array)
    # Break out to avoid errors
    if !array.kind_of?(Array)
      return array
    end
    
    result = Array.new
    
    # Loop
    array.each do | item |
      if item.kind_of?(Array)
        result.push(fixSpaces(item))      
      elsif item.kind_of?(String)        
        if item.include?' '
          #TODO result.push('"'+item+'"')
          result.push(item) 
        else
          result.push(item)    
        end
      else
        result.push(item)        
      end      
    end
    
    return result
  end
end

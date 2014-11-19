begin
  require 'rest-client'
  require 'json'
rescue LoadError => e
  Puppet.info "Razor Puppet module requires 'rest-client' and 'json' ruby gems."
end

class Puppet::Provider::Rest < Puppet::Provider
  desc "Razor API REST calls"
  
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def exists?    
    @property_hash[:ensure] == :present
  end
  
  def create
    @property_flush[:ensure] = :present
  end

  def destroy        
    @property_flush[:ensure] = :absent
  end
        
  def self.prefetch(resources)        
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end  
  
  def self.get_objects(type)
    # TODO IP address and port (+ auth) FROM PUPPET/FILE ???
    ip = '192.168.50.13'
    port = '8080'
    
    url = "http://#{ip}:#{port}/api/collections/#{type}"
    
    responseJson = get_json_from_url(url)

    items = responseJson["items"]

    objects = items.collect do |item|       
      get_object(item['name'], item['id'])
    end    
    
    Puppet.debug("Retrieved #{type} from REST API: #{objects}")
    
    objects
  end
  
  def post_command(command, resourceHash)     
    Puppet.debug("REST API => API: #{command}")    
    
    # TODO IP address and port (+ auth) FROM PUPPET/FILE ???
    ip = '192.168.50.13'
    port = '8080'
    
    url = "http://#{ip}:#{port}/api/commands/#{command}"
    
    begin
      RestClient.post url, resourceHash.to_json, :content_type => :json
    rescue => e
      Puppet.debug "Razor REST response: "+e.response
      Puppet.warning "Unable to #{command} on Razor Server through REST interface (#{ip}:#{port})"
    end       
  end
  
  def self.get_json_from_url(url)
    begin
      response = RestClient.get url
    rescue => e
      Puppet.debug "Razor REST response: "+e.response
      Puppet.warning "Unable to contact Razor Server through REST interface (#{url})"
    end
  
    begin
      responseJson = JSON.parse(response)
    rescue
      raise "Could not parse the JSON response from Razor: " + response
    end
  
    responseJson
  end
end

begin
  require 'rest-client' if Puppet.features.rest_client?
  require 'json' if Puppet.features.json?
rescue LoadError => e
  Puppet.info "Razor Puppet module requires 'rest-client' and 'json' ruby gems."
end

class Puppet::Provider::Rest < Puppet::Provider
  desc "Razor API REST calls"
  
  confine :feature => :json
  confine :feature => :rest_client
  
  def initialize(value={})
    super(value)
    @property_flush = {} 
  end
  
  def self.get_rest_info
    # Shiro Authentication is not (yet) configured. Authentication could possibly happen here?
    
    # IP Address:
       # As long as the custom types are configured on the same host as razor server is configured, the IP will be localhost.
       # I can not find any reasons why you would want the custom type to be configured on another host...
    # Port: 
      # The port config is very well hidden in torquebox (jboss) configuration. 
      # It's very unlikely that it will be changed.    
    
    # If the above changes, read the below variables from a config file
    
    ip = '127.0.0.1'
    port = '8080'
           
    { :ip   => ip,
      :port => port }
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
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/collections/#{type}"
    
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
    
    rest = self.class.get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/commands/#{command}"
    
    begin
      RestClient.post url, resourceHash.to_json, :content_type => :json
    rescue => e
      Puppet.debug "Razor REST response: "+e.inspect
      Puppet.warning "Unable to #{command} on Razor Server through REST interface (#{rest[:ip]}:#{rest[:port]})"
    end       
  end
  
  def self.get_json_from_url(url)
    begin
      response = RestClient.get url
    rescue => e
      Puppet.debug "Razor REST response: "+e.inspect
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

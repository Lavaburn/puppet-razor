begin
  require 'rest-client'
  require 'json'
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
    # TODO SET UP IP/PORT/AUTH
    # 1. Check for File /etc/razor/api.yaml
      # LOAD FILE => settings
    # 2. If file does not exist: 
        
    ip = '127.0.0.1'
    port = '8080'  
    #TODO authentication details
        
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
    
    rest = get_rest_info
    url = "http://#{rest[:ip]}:#{rest[:port]}/api/commands/#{command}"
    
    begin
      RestClient.post url, resourceHash.to_json, :content_type => :json
    rescue => e
      Puppet.debug "Razor REST response: "+e
      Puppet.warning "Unable to #{command} on Razor Server through REST interface (#{ip}:#{port})"
    end       
  end
  
  def self.get_json_from_url(url)
    begin
      response = RestClient.get url
    rescue => e
      Puppet.debug "Razor REST response: "+e
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

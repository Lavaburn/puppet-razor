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
    config_file = "/etc/razor/api.yaml"

    data = File.read(config_file) or raise "Could not read setting file #{config_file}"    
    yamldata = YAML.load(data)
    
    if yamldata.include?('hostname')
      hostname = yamldata['hostname']
    else
      hostname = 'localhost'
    end

    if yamldata.include?('api_port')
      port = yamldata['api_port']
    else
      port = 8150
    end

    if yamldata.include?('http_method')
      http = yamldata['http_method']
    else
      http = 'http'
    end

    if yamldata.include?('client_cert')
      client_cert = yamldata['client_cert']
    else
      client_cert = "/etc/puppetlabs/puppet/ssl/certs/#{hostname}.pem"
    end

    if yamldata.include?('private_key')
      private_key = yamldata['private_key']
    else
      private_key = "/etc/puppetlabs/puppet/ssl/private_keys/#{hostname}.pem"
    end
    
    if yamldata.include?('ca_cert')
      ca_cert = yamldata['ca_cert']
    else
      ca_cert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
    end
    
    # TODO - Shiro Authentication
        
    { :ip   => hostname,
      :port => port,
      :http => http,
      :client_cert => client_cert,
      :private_key => private_key,
      :ca_cert => ca_cert }
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
    url = "#{rest[:http]}://#{rest[:ip]}:#{rest[:port]}/api/collections/#{type}"
    
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
    url = "#{rest[:http]}://#{rest[:ip]}:#{rest[:port]}/api/commands/#{command}"

    if rest[:port] == 'https'
      ssl_rest = RestClient::Resource.new(
        url,
        :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("#{rest[:client_cert]}")),
        :ssl_client_key  => OpenSSL::PKey::RSA.new(File.read("#{rest[:private_key]}")),
        :ssl_ca_file     => "#{rest[:ca_cert]}",
)
      rest = ssl_rest.post(resourceHash.to_json, :content_type => 'application/json')
    else
      rest = RestClient.post url, resourceHash.to_json, :content_type => :json


    begin
    rest
    rescue => e
      Puppet.debug "Razor REST response: "+e.inspect
      Puppet.warning "Unable to #{command} on Razor Server through REST interface (#{rest[:ip]}:#{rest[:port]})"
    end
  end

  def self.get_json_from_url(url)
    begin
      rest = get_rest_info
      ssl_rest = RestClient::Resource.new(
        url,
        :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("#{rest[:client_cert]}")),
        :ssl_client_key  => OpenSSL::PKey::RSA.new(File.read("#{rest[:private_key]}")),
        :ssl_ca_file     => "#{rest[:ca_cert]}",
)
      Puppet.debug("Using client cert at #{rest[:client_cert]} and private key at #{rest[:private_key]} with CA #{rest[:ca_cert]}.")
      response = ssl_rest.get
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

  def self.get_server_version()
    rest = get_rest_info
    url = "#{rest[:http]}://#{rest[:ip]}:#{rest[:port]}/api"

    responseJson = get_json_from_url(url)
    version = responseJson["version"]["server"] || "Unknown"
    version
  end
end

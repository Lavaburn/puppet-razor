# Custom Type: Razor - Broker

Puppet::Type.newtype(:razor_broker) do
  @doc = "Razor Broker"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The broker name"    
  end
  
  newproperty(:broker_type) do                    # TODO API change?
    desc "The broker type"      
  end
  
  newproperty(:configuration) do
    desc "The broker configuration (Hash)"      
  end
  
  # This is not support by Puppet (<= 3.7)...
#  autorequire(:class) do
#    'razor'
#  end
end
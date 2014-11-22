# Custom Type: Razor - Broker

Puppet::Type.newtype(:razor_broker) do
  @doc = "Razor Broker"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The broker name"    
  end
  
  newproperty(:broker_type) do
    desc "The broker type"      
  end
  
  newproperty(:configuration) do
    desc "The broker configuration (Hash)"      
  end
  
  autorequire(:class) do
    'razor'
  end
end
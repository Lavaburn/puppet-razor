# Custom Type: Razor - Tag

Puppet::Type.newtype(:razor_tag) do
  @doc = "Razor Tag"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The tag name"    
  end
      
  newproperty(:rule, :array_matching => :all) do
    desc "The tag rule (Array)"
  end

  # This is not support by Puppet (<= 3.7)...
#  autorequire(:class) do
#    'razor'
#  end
end
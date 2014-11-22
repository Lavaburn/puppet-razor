# Custom Type: Razor - Policy

Puppet::Type.newtype(:razor_policy) do
  @doc = "Razor Policy"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The policy name"    
  end
    
  newproperty(:repo) do
    desc "The repository to install from"      
  end

  newproperty(:task) do
    desc "The task to use to install the repo"      
  end
      
  newproperty(:broker) do
    desc "The broker to use after installation"      
  end
      
  newproperty(:hostname) do
    desc "The hostname to set up (use ${id} inside)"      
  end
      
  newproperty(:root_password) do
    desc "The root password to install with"      
  end
      
  newproperty(:max_count) do
    desc "The maximum hosts to configure (set nil for unlimited)"      
  end
  
  newproperty(:before_policy) do
    desc "The policy before this one"
    
    def insync?(is)
      true
    end
  end
  
  newproperty(:after_policy) do
    desc "The policy after this one"
        
    def insync?(is)
      true
    end
  end
  
  newproperty(:node_metadata) do
    desc "The node metadata [Hash]"      
  end
  
  newproperty(:tags, :array_matching => :all) do
    desc "The tags to look for [Array]"      
  end
  
  newproperty(:enabled) do
    desc "Policies can be enabled or disabled"
    
    newvalues(:true, :false)
    defaultto(:true)
  end
  
  autorequire(:razor_broker) do
    self[:broker]
  end
  
  autorequire(:razor_repo) do
    self[:repo]
  end
    
  autorequire(:razor_tag) do
    self[:tags]
  end
  
  autorequire(:class) do
    'razor'
  end
  
  validate do    
    if self[:before_policy] != nil and self[:after_policy] != nil  then
      raise(ArgumentError,"razor_policy can not define both before_policy and after_polciy.")
    end
  end 
end
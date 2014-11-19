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
  
  newproperty(:before) do
    desc "The policy before this one"
    #TODO EITHER/OR
    
    def insync?(is)
      true
    end
  end
  
  newproperty(:after) do
    desc "The policy after this one"
    #TODO EITHER/OR
    
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
end

#newvalue(:true)
#newvalue(:false)

#validate do |value|
#  unless value =~ /^\w+/
#    raise ArgumentError, "%s is not a valid user name" % value
#  end
#end

#newvalues(:red, :green, :blue, :purple)

#newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean)
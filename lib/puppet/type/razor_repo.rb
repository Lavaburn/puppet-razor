# Custom Type: Razor - Repository

Puppet::Type.newtype(:razor_repo) do
  @doc = "Razor Repository"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The repository name"    
  end
  
  newproperty(:iso_url) do
    desc "The URL of the ISO to download"
    #TODO EITHER/OR
  end
  
  newproperty(:url) do
    desc "The URL of a mirror (no downloads)"
    #TODO EITHER/OR
  end
    
  newproperty(:task) do
    desc "The default task to perform to install the OS"
        
   end
end

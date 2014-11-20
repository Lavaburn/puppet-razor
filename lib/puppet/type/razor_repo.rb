# Custom Type: Razor - Repository

Puppet::Type.newtype(:razor_repo) do
  @doc = "Razor Repository"

  ensurable
  
  newparam(:name, :namevar => true) do
    desc "The repository name"    
  end
  
  newproperty(:iso_url) do
    desc "The URL of the ISO to download"
  end
  
  newproperty(:url) do
    desc "The URL of a mirror (no downloads)"
  end
    
  newproperty(:task) do
    desc "The default task to perform to install the OS"        
   end
   
   validate do
     if self[:iso_url] == nil and self[:url] == nil  then
       raise(ArgumentError,"razor_repo must define either iso_url (download) or url (link)")
     end
     
     if self[:iso_url] != nil and self[:url] != nil  then
       raise(ArgumentError,"razor_repo must define either iso_url (download) or url (link)")
     end
   end 
end

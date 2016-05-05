require "puppet/parameter/boolean"

Puppet::Type.newtype(:razor_hook) do
  @doc = "Razor Hook"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the hook"
  end

  newproperty(:hook_type) do
    desc "The hook type"
  end

 newproperty(:configuration) do
    desc "The configuration for this hook"
  end

 newparam(:mutable_configuration, :boolean => true, :parent => Puppet::Parameter::Boolean)

end

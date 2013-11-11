Puppet::Type.newtype(:rabbitmq_user) do

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end
  
  newparam(:password) do
    newvalues(/\S+/)
  end

  newproperty(:admin) do
    newvalues(/true|false/)
    munge do |value|
      value.to_s.to_sym
    end
    defaultto :false
  end

end

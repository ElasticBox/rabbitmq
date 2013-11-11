Puppet::Type.newtype(:rabbitmq_user_permissions) do

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end

  newproperty(:configure_permission) do
    newvalues(/\S+/)
  end

  newproperty(:read_permission) do
    newvalues(/\S+/)
  end

  newproperty(:write_permission) do
    newvalues(/\S+/)
  end
end

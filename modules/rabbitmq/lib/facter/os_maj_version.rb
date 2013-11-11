Facter.add(:os_maj_version) do
  v = Facter.value(:operatingsystemrelease)
  setcode do
    v.split('.')[0].strip
  end
end

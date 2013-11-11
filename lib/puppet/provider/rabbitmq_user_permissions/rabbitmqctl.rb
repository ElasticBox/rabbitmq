Puppet::Type.type(:rabbitmq_user_permissions).provide(:rabbitmqctl) do

  defaultfor :kernel => 'Linux'
  commands :rabbitmqctl => 'rabbitmqctl'
  
  def self.users(name)
    @users = {} unless @users
    unless @users[name]
      @users[name] = {}
      out = rabbitmqctl('list_user_permissions', name).split(/\n/)[1..-2].each do |line|
        @users[name] = {:configure => $2, :read => $3, :write => $4}
      end
    end
    @users[name]
  end

  def users(name)
    self.class.users(name)
  end

  def create
    rabbitmqctl(
      'set_permissions', 
      resource[:name], 
      resource[:configure_permission], 
      resource[:read_permission], 
      resource[:write_permission]
    ) 
  end

  def destroy
    rabbitmqctl('clear_permissions', resource[:name])
  end

  def exists?
    users(resource[:name])
  end

  def configure_permission
    users(resource[:name])[:configure]
  end

  def configure_permission=(perm)
    set_permissions
  end

  def read_permission
    users(resource[:name])[:read]
  end

  def read_permission=(perm)
    set_permissions
  end

  def write_permission
    users(resource[:name])[:write]
  end

  def write_permission=(perm)
    set_permissions
  end

  def set_permissions
    unless @permissions_set
      @permissions_set = true
      resource[:configure_permission] ||= configure_permission
      resource[:read_permission]      ||= read_permission
      resource[:write_permission]     ||= write_permission
      
      rabbitmqctl(
        'set_permissions', 
        resource[:name],
        resource[:configure_permission], 
        resource[:read_permission],
        resource[:write_permission]
      )
    end
  end

end

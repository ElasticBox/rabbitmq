#
# Class rabbitmq
#
class rabbitmq(
  $port        = 5672,
  $mnesia_base = '/var/lib/rabbitmq/mnesia',
  $log_base    = '/var/log/rabbitmq',
  $username    = 'guest',
  $password    = 'guest',
  $version     = undef,
  $node_name   = undef,

) {
  
  include 'rabbitmq::epel'
  include 'rabbitmq::params'
  
  Class['rabbitmq'] -> Class['rabbitmq::config']
  Class['rabbitmq::package'] -> Class['rabbitmq::config']

  $config_hash = {
    'port'        => "${port}",
    'mnesia_base' => "${mnesia_base}",
    'log_base'    => "${log_base}",
    'username'    => "${username}",
    'password'    => "${password}",
    'node_name'   => "${node_name}",
  }

  $config_class = { 'rabbitmq::config' => $config_hash }

  create_resources( 'class', $config_class )

  package { $rabbitmq::params::erlang_packages:
    ensure  => present,
    require => Class['rabbitmq::epel'],
  }
  
  class { 'rabbitmq::package':
    version => $version,
    require => Package[$rabbitmq::params::erlang_packages], 
  }
  
  service { 'rabbitmq-server' :
    ensure  => running,
    enable  => true,
    require => Class['rabbitmq::package']
  }
  
}

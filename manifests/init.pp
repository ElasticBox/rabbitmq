#
# Class rabbitmq
#
class rabbitmq(
  $port         = 5672,
  $ssl_port     = 5671,
  $key_path     = undef,
  $cert_path    = undef,
  $ca_cert_path = undef,
  $mnesia_base  = '/var/lib/rabbitmq/mnesia',
  $log_base     = '/var/log/rabbitmq',
  $user_name    = 'guest',
  $password     = 'guest',
  $version      = undef,
  $node_name    = undef,

) {
  
  include 'rabbitmq::epel'
  include 'rabbitmq::params'
  
  Class['rabbitmq'] -> Class['rabbitmq::config']
  Class['rabbitmq::package'] -> Class['rabbitmq::config']

  $config_hash = {
    'port'         => "${port}",
    'ssl_port'     => "${ssl_port}",
    'key_path'     => "${key_path}",
    'cert_path'    => "${cert_path}",
    'ca_cert_path' => "${ca_cert_path}",
    'mnesia_base'  => "${mnesia_base}",
    'log_base'     => "${log_base}",
    'user_name'    => "${user_name}",
    'password'     => "${password}",
    'node_name'    => "${node_name}",
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
  
}

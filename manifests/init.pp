#
# Class rabbitmq
#
class rabbitmq(
  $port         = 5672,
  $ssl_port     = 5671,
  $key_file     = undef,
  $cert_file    = undef,
  $ca_cert_file = undef,
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
    'key_file'     => "${key_file}",
    'cert_file'    => "${cert_file}",
    'ca_cert_file' => "${ca_cert_file}",
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
  
  service { 'rabbitmq-server' :
    ensure  => running,
    enable  => true,
    require => Class['rabbitmq::package']
  }
  
}

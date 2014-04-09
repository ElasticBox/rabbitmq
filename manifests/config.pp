#
# Class rabbitmq::config
#
class rabbitmq::config(
  $port        = 5672,
  $ssl_port     = 5671,
  $key_file     = undef,
  $cert_file    = undef,
  $ca_cert_file  = undef,
  $mnesia_base = '/var/lib/rabbitmq/mnesia',
  $log_base    = '/var/log/rabbitmq',
  $user_name    = 'guest',
  $password    = 'guest',
  $node_name   = undef,
) {
  
  File {
    ensure => present,
    owner  => "rabbitmq",
    group  => "rabbitmq",
  }
  
  exec { 'rabbitmq-stop':
    command   => 'service rabbitmq-server stop;',
    path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    logoutput => true,
  }
  
  exec { 'create_mnesia':
    command   => "mkdir -p ${mnesia_base}",
    path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    logoutput => true,
    unless    => "test -d ${mnesia_base}",
    require   => Exec['rabbitmq-stop'],
  }
  
  file { $mnesia_base:
    ensure  => directory,
    mode    => 0755,
    require => Exec['create_mnesia'],
  }
  
  exec { 'create_log':
    command   => "mkdir -p ${log_base}",
    path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    logoutput => true,
    unless    => "test -d ${log_base}",
    require   => Exec['rabbitmq-stop'],
  }
  
  file { $log_base:
    ensure  => directory,
    mode    => 0755,
    require => Exec['create_log'],
  }
  
  file { '/etc/rabbitmq/rabbitmq-env.conf':
    content => template('rabbitmq/rabbitmq-env.conf.erb'),
    require => [File[$mnesia_base],File[$log_base]],
  }
  
  file { '/etc/rabbitmq/rabbitmq.config':
    content => template('rabbitmq/rabbitmq.config.erb'),
    require => File['/etc/rabbitmq/rabbitmq-env.conf'],
  }
  
  exec { 'rabbitmq-start':
    command   => 'service rabbitmq-server start',
    path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    logoutput => true,
    require   => File['/etc/rabbitmq/rabbitmq.config'],
  }  
  
}

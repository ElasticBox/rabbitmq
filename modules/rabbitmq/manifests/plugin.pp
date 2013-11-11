#
# Define Rabbitmq::plugin
#
define rabbitmq::plugin(
  $ensure = undef,
) {

  if ($ensure == 'present') {
    exec{ "rabbitmq-plugins-${name}":
      command     => "rabbitmq-plugins enable ${name}",
      path        => "/usr/bin:/usr/sbin:/bin",
      environment => "HOME=/root",
      unless      => "test rabbitmq-plugins list -E | grep ${name}",
      notify      => Exec["rabbitmq-restart-${name}-${ensure}"],
    }
  } elsif ($ensure == 'absent') {
    exec{ "rabbitmq-plugins-${name}":
      command     => "rabbitmq-plugins enable ${name}",
      path        => "/usr/bin:/usr/sbin:/bin",
      environment => "HOME=/root",
      unless      => "test -z rabbitmq-plugins list -E | grep ${name}",
      notify      => Exec["rabbitmq-restart-${name}-${ensure}"],
    }
  } else {
    fail("ensure parameter value must be absent or present")
  }
  
  exec { "rabbitmq-restart-${name}-${ensure}":
    command     => 'service rabbitmq-server restart; rabbitmqctl start_app;',
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
    logoutput   => true,
    refreshonly => true,
  }
  
}
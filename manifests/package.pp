#
# Class rabbitmq::package
#
class rabbitmq::package(
  $version = undef,
) {
  
  if ($osfamily == 'RedHat' or $operatingsystem == 'Amazon') {
    
    package { $rabbitmq::params::erlang_packages:
      ensure  => present,
      require => Class['rabbitmq::epel'],
    }

    exec { 'wget-rpm':
      command   => "wget http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/rabbitmq-server-${version}-1.noarch.rpm",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -z $(which rabbitmq-server)",
      require   => Package[$rabbitmq::params::erlang_packages]
    }
    
    exec { 'install-rpm':
      command   => "yum install rabbitmq-server-${version}-1.noarch.rpm -y",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -z $(which rabbitmq-server)",
      tries     => 5,
      require   => Exec['wget-rpm'],
    }
    
    exec { 'clean-rpm':
      command   => "rm -f rabbitmq-server-${version}-1.noarch.rpm",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -f rabbitmq-server-${version}-1.noarch.rpm",
      require   => Exec["install-rpm"]
    }
  }
  elsif ($osfamily == 'Debian') {
    exec { 'add_apt':
      command   => "echo 'deb http://www.rabbitmq.com/debian/ testing main' >> /etc/apt/sources.list",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "cat /etc/apt/sources.list | grep rabbitmq",
    }
    
    exec { 'download_key':
      command   => "wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "apt-key list | grep rabbitmq",
      require   => Exec['add_apt'],
    }
    
    exec { 'install_key':
      command   => "apt-key add rabbitmq-signing-key-public.asc",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "apt-key list | grep rabbitmq",
      require   => Exec['download_key'],
    }

    exec { 'apt_update':
      command   => "apt-get update",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      require   => Exec['install_key'],
    }

    package { 'rabbitmq-server':
      ensure  => "${version}-1",
      require => Exec['apt_update'],
    }
  }
}

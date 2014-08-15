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
    package { $rabbitmq::params::erlang_packages:
      ensure  => present,
    }
    
    exec { 'wget-deb':
      command   => "wget http://www.rabbitmq.com/releases/rabbitmq-server/v${version}/rabbitmq-server_${version}-1_all.deb",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -z $(which rabbitmq-server)",
      require   => Package[$rabbitmq::params::erlang_packages]
    }
    
    exec { 'install-deb':
      command   => "dpkg -i rabbitmq-server_${version}-1_all.deb",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -z $(which rabbitmq-server)",
      tries     => 5,
      require   => Exec['wget-deb'],
    }
    
    exec { 'clean-deb':
      command   => "rm -f rabbitmq-server_${version}-1_all.deb",
      path      => '/usr/bin:/usr/sbin:/bin:/sbin',
      logoutput => true,
      unless    => "test ! -f rabbitmq-server_${version}-1_all.deb",
      require   => Exec['install-deb'],
    }
  }
}

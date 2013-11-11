#
# Class rabbitmq::epel
#
class rabbitmq::epel {
  
  if ($osfamily == 'RedHat' and $operatingsystem != 'Fedora') {
    
    yumrepo { 'epel':
      descr          => "Extra Packages for Enterprise Linux ${os_maj_version} - \$basearch",
      mirrorlist     => "https://mirrors.fedoraproject.org/metalink?repo=epel-${os_maj_version}&arch=\$basearch",
      failovermethod => 'priority',
      enabled        => '1',
      gpgcheck       => '1',
      gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${os_maj_version}",
    }
    
    yumrepo { 'epel-debuginfo':
      descr          => "Extra Packages for Enterprise Linux ${os_maj_version} - \$basearch - Debug",
      mirrorlist     => "https://mirrors.fedoraproject.org/metalink?repo=epel-debug-${os_maj_version}&arch=\$basearch",
      failovermethod => 'priority',
      enabled        => '0',
      gpgcheck       => '1',
      gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${os_maj_version}",
      require        => Yumrepo['epel'],
    }
    
    yumrepo { 'epel-source':
      descr          => "Extra Packages for Enterprise Linux ${os_maj_version} - \$basearch - Source",
      mirrorlist     => "https://mirrors.fedoraproject.org/metalink?repo=epel-source-${os_maj_version}&arch=\$basearch",
      failovermethod => 'priority',
      enabled        => '0',
      gpgcheck       => '1',
      gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${os_maj_version}",
      require        => Yumrepo['epel-debuginfo'],
    }
    
    exec { 'gpg-key-rabbitmq':
      command   => "curl http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${os_maj_version} > /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${os_maj_version}",
      path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
      logoutput => true,
      unless    => "test -f /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${os_maj_version}",
      require   => Yumrepo['epel-source'],
    }

    # Puppet bug with yum provider, need to execute a command at the end to return 0
    exec { 'yum-check-update-rabbitmq':
      command   => 'yum check-update;echo $?',
      path      => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
      user      => 'root',
      tries     => 5,
      logoutput => true,
      require   => Exec['gpg-key-rabbitmq']
    }
  }
  
}

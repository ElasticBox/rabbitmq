#
# Class rabbitmq::params
#
class rabbitmq::params() {
  
   case $::operatingsystem {
    /(Amazon|CentOS|Fedora|RedHat)/: {
      $erlang_packages = [ 'erlang', 'wget' ]
    }
    /(Debian|Ubuntu)/: {
      $erlang_packages = [ 'erlang', 'erlang-nox' ]
    }
    default: {
      fail('Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}')
    }
  }
}
# Class: iptables::params
#
# Sets internal variables and defaults for iptables module
# This class is loaded in all the classes that use the values set here
#
class iptables::params  {

  ### Definition of some variables used in the module
  $osver = split($::operatingsystemrelease, '[.]')
  $osver_maj = $osver[0]

  $package_name = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'iptables-persistent',
    default => 'iptables',
  }

  $service_name = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'iptables-persistent',
    default                   => 'iptables',
  }

  case $::operatingsystem {
    /(?i:Debian)/: {
      if (($osver_maj =~ /^\d+$/) and ($osver_maj < 7)) {
        $config_file_path_v4 = '/etc/iptables/rules'
      } else {
        $config_file_path_v4 = '/etc/iptables/rules.v4' # Introduced in iptables-persistent 0.5/wheezy
      }
    }
    /(?i:Ubuntu)/: {
      if (($osver_maj =~ /^\d+$/) and ($osver_maj < 12)) {
        $config_file_path_v4 = '/etc/iptables/rules'
      } else {
        $config_file_path_v4 = '/etc/iptables/rules.v4' # Introduced in iptables-persistent 0.5/Ubuntu 12.04
      }
    }
    /(?i:Mint)/: {
      if (($osver_maj =~ /^\d+$/) and ($osver_maj < 13)) {
        $config_file_path_v4 = '/etc/iptables/rules'
      } else {
        $config_file_path_v4 = '/etc/iptables/rules.v4' # Introduced in iptables-persistent 0.5/Mint 13
      }
    }
    default: {
      $config_file_path_v4 = '/etc/sysconfig/iptables'
    }
  }
  
  $config_file_path_v6 = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/                           => '/etc/iptables/rules.v6',
    /(?i:RedHat|CentOS|Scientific|Amazon|Linux|Fedora)/ => '/etc/sysconfig/ip6tables',
    default                                             => '/etc/iptables/rules.v6',
  }
  
  $config_dir_path = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/                           => '/etc/iptables',
    /(?i:RedHat|CentOS|Scientific|Amazon|Linux|Fedora)/ => '/etc/sysconfig',
    default                                             => '/etc/iptables',
  }

# Module specific variables
  
  # See: https://github.com/example42/puppet-iptables/commit/2f1a23d426a0b8a4ebf7a61b338fdc0d151509f8
  $enable_v4 = $::ipaddress != ''
  $enable_v6 = $::ipaddress6 != ''

  # This should be dependent on the kernel, netfilter version and capabilities
  $configure_ipv6_nat = false

  # use "$service restart" to load new firewall rules?
  $service_override_restart = $::operatingsystem ? {
    /(?i:Ubuntu)/ => false, # Don't know about other distro's. Who does?
    default       => true,
  }
  
  $service_status_cmd = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/bin/true',
    default                   => undef,
  }
  
#    $service_status = $::operatingsystem ? {
#    /(?i:Debian|Ubuntu|Mint)/ => false,
#    default                   => true,
#  }

  case $::osfamily {
    'Debian','RedHat': { }
    default: {
      fail("${::operatingsystem} not supported. At least not yet, but you can change that!")
    }
  }

}

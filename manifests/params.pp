# Class: keymaster::params
#
# This class manages shared prameters and variables for the keymaster module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class keymaster::params {

  $keystore_base     = '/var/lib/keymaster'
  $keystore_openssh  = "${keystore_base}/openssh"
  $keystore_host_key = "${keystore_base}/host_key"
  $keystore_x509     = "${keystore_base}/x509"
  $user              = 'puppet'
  $group             = 'puppet'

  case $::osfamily {
    Debian:{
      # Do nothing
    }
    RedHat:{
      # Do nothing
    }
    default:{
      fail("The keymaster Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}

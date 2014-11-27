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

  case $::osfamily {
    Debian:{
      # Do nothing
    }
    default:{
      fail("The keymaster Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}

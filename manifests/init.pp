# Class: keymaster
#
# This module sets up a puppetmaster as a keymaster for holding and issuing
# keys and certificates.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

# This file is part of the keymaster Puppet module.
#
# [Remember: No empty lines between comments and class definition]
class keymaster (
  $keystore_base    = $::keymaster::params::keystore_base,
  $keystore_openssh = $::keymaster::params::keystore_openssh,
  $user             = $::keymaster::params::user,
  $group            = $::keymaster::params::group
) inherits keymaster::params {

  # Set up base directory for key storage
  file { 'key_store_base':
    ensure  => 'directory',
    path    => $keystore_base,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  file { 'key_store_openssh':
    ensure  => 'directory',
    path    => $keystore_openssh,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  # Collect all keys
  # Keymaster::Openssh::keys <<| |>>

}

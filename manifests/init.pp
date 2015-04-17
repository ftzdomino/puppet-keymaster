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
  $user             = $::keymaster::params::user,
  $group            = $::keymaster::params::group
) inherits keymaster::params {

  # Set up base directory for key storage
  file { 'key_store_base':
    ensure  => 'directory',
    path    => $::keymaster::params::keystore_base,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  file { 'key_store_openssh':
    ensure  => 'directory',
    path    => $::keymaster::params::keystore_openssh,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  file { 'key_store_host_key':
    ensure  => 'directory',
    path    => $::keymaster::params::keystore_host_key,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  file { 'key_store_x509':
    ensure  => 'directory',
    path    => $::keymaster::params::keystore_x509,
    owner   => $user,
    group   => $group,
    recurse => true,
    mode    => '0640',
  }

  # Collect all keys
  Keymaster::Openssh::Key::Generate <<| |>>
  Keymaster::Host_key::Key::Generate <<| |>>
  Keymaster::X509::Cert::Generate <<| |>>
  Keymaster::X509::Cert::Pem <<| |>>
  Keymaster::X509::Cert::P12 <<| |>>

}

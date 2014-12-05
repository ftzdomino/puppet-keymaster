# Deploy a previousl defined key to a user's .ssh/authorized_key file
define keymaster::openssh::authorize (
  $ensure  = undef,
  $user    = undef,
  $options = undef,
) {

  $clean_name = regsubst($name, '@', '_at_')
  # Override the defaults set in sshauth::key, as needed.

  # This is ugly, but we need to accomodate every permutation of the 
  # three params.  Otherwise override bahavior is unpredictible.
  #
  if ( $user and $ensure and $options ) {
  #notify {"sshauth::server: user and ensure and options":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      user    => $user,
      ensure  => $ensure,
      options => $options,
    }

  } elsif ( $user and $ensure ) {
  #notify {"sshauth::server: user and ensure":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      ensure => $ensure,
      user   => $user,
    }

  } elsif ( $user and $options ) {
  #notify {"sshauth::server: user and options":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      user    => $user,
      options => $options,
    }

  } elsif ( $options and $ensure ) {
  #notify {"sshauth::server: options and ensure":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      ensure  => $ensure,
      options => $options,
    }

  } elsif $user {
  #notify {"sshauth::server: user only":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      user  => $user,
    }

  } elsif $ensure {
  #notify {"sshauth::server: ensure only":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      ensure  => $ensure,
    }

  } elsif $options {
  #notify {"sshauth::server: options only":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>> {
      options => $options,
    }

  } else {
  #notify {"sshauth::server: default":}
    Keymaster::Openssh::Key::Authorized_key <<| tag == $clean_name |>>
  }

}
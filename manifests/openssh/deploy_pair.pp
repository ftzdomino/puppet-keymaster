# This resource deploys an instances of a key pair
define keymaster::openssh::deploy_pair (
  $ensure   = undef,
  $user     = undef,
  $filename = undef
) {

  validate_re($ensure,['^present$','^absent$'])

  $clean_name = regsubst($name, '@', '_at_')

  # This is ugly, but we need to accomodate every permutation of the 
  # three params.  Otherwise override behavior is unpredictible.
  if ( $user and $ensure and $filename ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      user      => $user,
      ensure    => $ensure,
      filename  => $filename,
    }

  } elsif ( $user and $ensure ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      user   => $user,
      ensure => $ensure,
    }

  } elsif ( $ensure and $filename ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      ensure   => $ensure,
      filename => $filename,
    }

  } elsif ( $user and $filename ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      user     => $user,
      filename => $filename,
    }

  } elsif ( $user ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      user => $user,
    }

  } elsif ( $ensure ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      ensure => $ensure,
    }

  } elsif ( $filename ) {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>> {
      filename => $filename,
    }

  } else {
    Keymaster::Openssh::Key::Deploy <<| tag == $clean_name |>>
  }

}
# This defines an openssh host key
define keymaster::host_key::key (
  $ensure   = 'present',
  $keytype  = 'rsa',
  $length   = '2048',
  $maxdays  = undef,
  $mindate  = undef,
  $force    = false,
  $deploy   = false,
) {

  validate_re($ensure,['^present$','^absent$'])
  validate_re($keytype, ['^rsa$','^dsa$'])

  case $keytype {
    'dsa':{
      $real_length = '1024'
    }
    default:{
      $real_length = $length
    }
  }

  validate_re(
    $name,
    '^[A-Za-z0-9][A-Za-z0-9_.-]+$',
    "${name} must start with a letter or digit, and may only contain the characters A-Za-z0-9_.-"
  )

  # generate exported resources for the keymaster to realize
  @@keymaster::host_key::key::generate { $name:
    ensure  => $ensure,
    force   => $force,
    keytype => $keytype,
    length  => $real_length,
    maxdays => $maxdays,
    mindate => $mindate,
    tag     => $name,
  }

  # generate exported resources for the ssh client host to realize
  @@keymaster::host_key::key::deploy { $name:
    ensure => $ensure,
    tag    => $name,
  }

  if $deploy {
    keymaster::host_key::redeploy { $name:
      ensure => $ensure
    }
  }
}
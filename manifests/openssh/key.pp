# This defines an openssh key pair
define keymaster::openssh::key (
  $ensure   = 'present',
  $filename = undef,
  $keytype  = 'rsa',
  $length   = '2048',
  $maxdays  = undef,
  $mindate  = undef,
  $force    = false,
  $options  = undef
) {

  validate_re($keytype, ['^rsa$','^dsa$'])

  if $filename {
    $real_filename = $filename
  } else {
    $real_filename = "id_${keytype}"
  }

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
    '^[A-Za-z0-9][A-Za-z0-9_.:@-]+$',
    "${name} must start with a letter or digit, and may only contain the characters A-Za-z0-9_.:@-"
  )

  $clean_tag = regsubst($name, '@', '_at_')

  # generate exported resources for the keymaster to realize
  @@keymaster::openssh::key::generate { $name:
    ensure  => $ensure,
    force   => $force,
    keytype => $keytype,
    length  => $real_length,
    maxdays => $maxdays,
    mindate => $mindate,
    tag     => $clean_tag,
  }

  # generate exported resources for the ssh client host to realize
  @@keymaster::openssh::key::deploy { $name:
    ensure   => $ensure,
    filename => $real_filename,
    tag      => $tag,
  }

  # generate exported resources for the ssh server host to realize
  @@keymaster::openssh::key::authorized_key { $name:
    ensure  => $ensure,
    options => $options,
    tag     => $tag,
  }

}

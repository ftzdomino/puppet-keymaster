# Manages the creation, generation, and deletion of keys on the keymaster
define keymaster::openssh::key::generate (
  $ensure  = 'present',
  $force   = false,
  $keytype = 'rsa',
  $length  = '2048',
  $maxdays = undef,
  $mindate = undef
) {

  validate_re($keytype, ['^rsa$','^dsa$'])

  if $keytype == 'dsa' {
    $real_length = '1024'
  } else {
    $real_length = $length
  }

  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

  File {
    owner => $::keymaster::user,
    group => $::keymaster::group,
    mode  => '0600',
  }

  $clean_name = regsubst($name, '@', '_at_')
  $keydir     = "${::keymaster::keystore_openssh}/${clean_name}"
  $keyfile    = "${keydir}/key"

  file { "${name}_dir":
    ensure => directory,
    path   => $keydir,
    mode   => '0644',
  }
  
  file { "${name}_key":
    ensure => $ensure,
    path   => $keyfile,
  }
  
  file { "${name}_pub":
    ensure => $ensure,
    path   => "${keyfile}.pub"
  }

  if $ensure == 'present' {
  # Remove the existing key pair, if
  # * $force is true, or
  # * $maxdays or $mindate criteria aren't met, or
  # * $keytype or $length have changed
    $keycontent = file("${keyfile}.pub", '/dev/null')
    if $keycontent {
      if $force {
        $reason = 'force=true'
      }

      if !$reason and $mindate and generate('/usr/bin/find', $keyfile, '!', '-newermt', $mindate) {
          $reason = "created before ${mindate}"
      }

      if !$reason and $maxdays and generate('/usr/bin/find', $keyfile, '-mtime', "+${maxdays}") {
        $reason = "older than ${maxdays} days"
      }

      if !$reason and $keycontent =~ /^ssh-... [^ ]+ (...) (\d+)$/ {
        if $keytype != $1 {
          $reason = "keytype changed: $1 -> ${keytype}" # lint:ignore:variables_not_enclosed
        } else {
          if $length != $2 {
            $reason = "length changed: $2 -> ${length}" # lint:ignore:variables_not_enclosed
          }
        }
      }

      if $reason {
        exec { "Revoke previous key ${name}: ${reason}":
          command => "rm ${keyfile} ${keyfile}.pub",
          before  => Exec["Create key ${name}: ${keytype}, ${length} bits"],
        }
      }
    }

    # Create the key pair.
    # We "repurpose" the comment field in public keys on the keymaster to
    # store data about the key, i.e. $keytype and $length.  This avoids
    # having to rerun ssh-keygen -l on every key at every run to determine
    # the key length.
    exec { "Create key ${name}: ${keytype}, ${real_length} bits":
      command => "ssh-keygen -t ${keytype} -b ${real_length} -f ${keyfile} -C '${keytype} ${real_length}' -N ''",
      user    => $::keymaster::user,
      group   => $::keymaster::group,
      creates => $keyfile,
      before  => [ File["${name}_key","${name}_pub"] ],
      require => File["${name}_dir"],
    }
  } # if $ensure  == "present"
}
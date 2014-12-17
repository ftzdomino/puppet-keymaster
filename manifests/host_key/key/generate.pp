# This generates a host key on the keymaster
define keymaster::host_key::key::generate(
  $ensure  = 'present',
  $force   = false,
  $keytype = 'rsa',
  $length  = '2048',
  $maxdays = undef,
  $mindate = undef
) {

  include keymaster::params

  validate_re($ensure,['^present$','^absent$'])
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

  $key_dir          = "${::keymaster::params::keystore_host_key}/${name}"
  $key_private_file = "${key_dir}/key"
  $key_public_file  = "${key_dir}/key.pub"

  file { "host_key_${name}_dir":
    ensure => directory,
    path   => $key_dir,
    mode   => '0644',
  }
  
  file { "host_key_${name}_key":
    ensure => $ensure,
    path   => $key_private_file,
  }
  
  file { "host_key_${name}_pub":
    ensure => $ensure,
    path   => $key_public_file,
  }

  if $ensure == 'present' {
  # Remove the existing key pair, if
  # * $force is true, or
  # * $maxdays or $mindate criteria aren't met, or
  # * $keytype or $length have changed
    $keycontent = file($key_public_file, '/dev/null')
    if $keycontent {
      if $force {
        $reason = 'force=true'
      }

      if !$reason and $mindate and generate('/usr/bin/find', $key_private_file, '!', '-newermt', $mindate) {
          $reason = "created before ${mindate}"
      }

      if !$reason and $maxdays and generate('/usr/bin/find', $key_private_file, '-mtime', "+${maxdays}") {
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
          command => "rm ${key_private_file} ${key_public_file}",
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
      command => "ssh-keygen -t ${keytype} -b ${real_length} -f ${key_private_file} -C '${keytype} ${real_length}' -N ''",
      user    => $::keymaster::user,
      group   => $::keymaster::group,
      creates => $key_private_file,
      before  => [ File["host_key_${name}_key","host_key_${name}_pub"] ],
      require => File["host_key_${name}_dir"],
    }
  } # if $ensure  == "present"
}
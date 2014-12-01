# Install a public key into a server user's authorized_keys(5) file.
define keymaster::openssh::key::authorized_key (
  $user,
  $ensure  = 'present',
  $options = undef,
) {

  # on the keymaster:
  $key_src_dir  = "${::keymaster::keystore_openssh}/${name}"
  $key_src_file = "${key_src_dir}/key.pub"
  $key_src_content = file($key_src_file, '/dev/null')

  # If absent, remove from authorized_keys
  if $ensure == 'absent' {
    ssh_authorized_key { $name:
      ensure => absent,
      user   => $user,
    }

  # If no key content, do nothing.  wait for keymaster to realise key resource
  } elsif ! $key_src_content {
    notify { "Public key file ${key_src_file} for key ${name} not found on keymaster; skipping": }

  # Make sure key content parses
  } elsif $key_src_content !~ /^(ssh-...) ([^ ]*)/ {
    err("Can't parse public key file ${key_src_file}")
    notify { "Can't parse public key file ${key_src_file} for key ${name} on the keymaster: skipping": }

  # All's good.  install the pubkey.
  } else {
    $keytype = $1
    $modulus = $2

    ssh_authorized_key { $name:
      ensure  => 'present',
      user    => $user,
      type    => $keytype,
      key     => $modulus,
      options => $options,
    }
  }
}
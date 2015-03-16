# This deploys a key onto the target node
define keymaster::x509::key::deploy(
  $path,
  $ensure = 'present',
  $owner  = undef,
  $group  = undef
) {

  validate_re($ensure,['^present$','^absent$'])

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    default: {
      $file_ensure = 'absent'
    }
  }

  $key_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  # filename of private key on the keymaster (source)
  $key_file = "${key_src_dir}/key.pem"

  # read contents of key from the keymaster
  $key_content  = file($key_file, '/dev/null')

  if ! $key_content {
    notify{"x509_${name}_did_not_run":
      message => "Can't read certificate ${key_file}",
    }
  } elsif ( $key_content =~ /^(ssh-...) (\S*)/ ) {

    file {"x509_${name}_key":
      ensure  => $file_ensure,
      path    => $path,
      owner   => $owner,
      group   => $owner,
      content => $key_content,
    }

  }
}

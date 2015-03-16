# This deploys a key onto the target node
define keymaster::x509::cert::deploy(
  $path,
  $ensure   = 'present',
  $type     = 'pem',
  $owner    = undef,
  $group    = undef
) {

  validate_re($ensure,['^present$','^absent$'])

  validate_re($type,['pem','cer','crt','der','p12'])

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    default: {
      $file_ensure = 'absent'
    }
  }

  $cert_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  # filename of private key on the keymaster (source)
  $cert_file = "${cert_src_dir}/cert.crt"

  # read contents of key from the keymaster
  $cert_content  = file($cert_file, '/dev/null')

  if ! $cert_content {
    notify{"x509_${name}_did_not_run":
      message => "Can't read certificate ${cert_file}",
    }
  } elsif ( $cert_content =~ /^(ssh-...) (\S*)/ ) {

    file {"x509_${name}_cert":
      ensure  => $file_ensure,
      path    => $path,
      owner   => $owner,
      group   => $owner,
      content => $cert_content,
    }

  }
}

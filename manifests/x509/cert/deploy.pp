# This deploys a key onto the target node
define keymaster::x509::cert::deploy(
  $ensure = 'present',
  $path   = undef,
  $type   = undef,
  $owner  = undef,
  $group  = undef
) {

  validate_re($ensure,['^present$','^absent$'])

  if $type {
    validate_re($type,['pem','cer','crt','der','p12'])
    $real_type = $type
  } else {
    $real_type = 'crt'
  }

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    default: {
      $file_ensure = 'absent'
    }
  }

  if $path {
    $real_path = $path
  } else {
    $real_path = "${::keymaster::params::x509_cert_dir}/${name}.${real_type}"
  }

  $cert_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  # filename of private key on the keymaster (source)
  $cert_file = "${cert_src_dir}/certificate.crt"

  # read contents of key from the keymaster
  case $real_type {
    'crt': {
      $cert_content  = file($cert_file, '/dev/null')
    }
    default: {
      fail("The certificate type ${real_type} is not yet supported.")
    }
  }
  
  if ! $cert_content {
    notify{"x509_${name}_did_not_run":
      message => "Can't read certificate ${cert_file}",
    }
  } else {

    file {"x509_${name}_certificate":
      ensure  => $file_ensure,
      path    => $real_path,
      owner   => $owner,
      group   => $owner,
      content => $cert_content,
    }

  }
}

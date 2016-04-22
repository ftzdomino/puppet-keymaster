# This deploys a key onto the target node
define keymaster::x509::key::deploy(
  $ensure = 'present',
  $path   = undef,
  $owner  = undef,
  $group  = undef
) {

  include ::keymaster::params

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

  if $path {
    $real_path = $path
  } else {
    $real_path = "${::keymaster::params::x509_key_dir}/${name}.pem"
  }

  if ! $key_content {
    notify{"x509_${name}_key_did_not_run":
      message => "Can't read key ${key_file}",
    }
  } else {

    file {"x509_${name}_private_key":
      ensure  => $file_ensure,
      path    => $real_path,
      owner   => $owner,
      group   => $owner,
      content => $key_content,
    }

  }
}

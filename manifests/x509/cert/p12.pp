# This resource converts a cer certificate to the pkcs12 format
define keymaster::x509::cert::p12 (
  $ensure = 'present',
  $type   = 'p12'
) {

  validate_re($type,['p12','pfx'])

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    default: {
      $file_ensure = 'absent'
    }
  }

  $cert_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  $cert_in_file  = "${cert_src_dir}/certificate.crt"
  $key_in_file   = "${cert_src_dir}/key.pem"
  $cert_out_file = "${cert_src_dir}/certificate.${type}"

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
    user => $::keymaster::user,
  }

  File {
    owner => $::keymaster::user,
    group => $::keymaster::group,
    mode  => '0640',
  }

  if $ensure == 'present' {
    exec { "convert_${name}_to_p12":
      command => "openssl pkcs12 -export -out ${cert_out_file} -in ${cert_in_file} -inkey ${key_in_file}",
      creates => $cert_out_file,
      before  => File["x509_${name}_p12"],
    }
  }

  file { "x509_${name}_p12":
    ensure => $file_ensure,
    path   => $cert_out_file
  }
}

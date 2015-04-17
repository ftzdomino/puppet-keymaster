# This resource converts a cer certificate to the pem format
define keymaster::x509::cert::pem (
  $ensure = 'present'
) {

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
  $cert_out_file = "${cert_src_dir}/certificate.pem"

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
    exec { "convert_${name}_to_pem":
      command => "openssl x509 -inform der -in ${cert_in_file} -out ${cert_out_file}",
      creates => $cert_out_file,
      before  => File["x509_${name}_pem"],
    }
  }

  file { "x509_${name}_pem":
    ensure => $file_ensure,
    path   => $cert_out_file
  }
}

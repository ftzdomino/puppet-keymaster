# This generates a host key on the keymaster
define keymaster::x509::cert::generate(
  $country,
  $organization,
  $commonname,
  $ensure   = 'present',
  $state    = undef,
  $locality = undef,
  $aliases  = [],
  $email    = undef,
  $days     = '365',
  $password = undef,
  $type     = 'pem',
  $force    = false,
) {

  include keymaster::params

  validate_re($ensure,['^present$','^absent$'])
  validate_re($type,['pem','cer','crt','der','p12'])

  case $ensure {
    'present': {
      $file_ensure = 'file'
      $dir_ensure = 'directory'
    }
    default: {
      $file_ensure = 'absent'
      $dir_ensure = 'directory'
    }
  }

  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

  File {
    owner => $::keymaster::user,
    group => $::keymaster::group,
    mode  => '0600',
  }

  # Define some paths.
  $cert_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  $cert_cnf_file = "${cert_src_dir}/cert.cnf"
  $cert_key_file = "${cert_src_dir}/key.pem"
  $cert_csr_file = "${cert_src_dir}/cert.csr"
  $cert_crt_file = "${cert_src_dir}/cert.crt"


  # Create the x509 store directory
  file{"x509_${name}_dir":
    ensure => $dir_ensure,
    path   => $cert_src_dir,
    mode   => '0644',
  }

  # Create cnf
  file{"x509_${name}_cnf":
    ensure  => $file_ensure,
    path    => $cert_cnf_file,
    content => template('keymaster/cert.cnf.erb'),
  }

  # Create private key
  exec{"x509_${name}_key":
    command => "openssl genrsa -out ${cert_key_file} 2048",
    user    => $::keymaster::user,
    group   => $::keymaster::group,
    creates => $cert_key_file,
    require => File["x509_${name}_cnf"],
  }

  # Create certificate signing request
  exec{"x509_${name}_csr":
    command => "openssl req -new -key ${cert_key_file} -out ${cert_csr_file} -config ${cert_cnf_file}",
    user    => $::keymaster::user,
    group   => $::keymaster::group,
    creates => $cert_csr_file,
    require => File["x509_${name}_key"],
  }

  # Create certificate signing request
  exec{"x509_${name}_crt":
    command => "openssl x509 -req -days ${days} -in ${cert_csr_file} -signkey ${cert_key_file} -out ${cert_crt_file}",
    user    => $::keymaster::user,
    group   => $::keymaster::group,
    creates => $cert_crt_file,
    require => File["x509_${name}_csr"],
  }

}

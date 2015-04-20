# This generates a host key on the keymaster
define keymaster::x509::cert::generate(
  $commonname,
  $ensure       = 'present',
  $country      = undef,
  $organization = undef,
  $state        = undef,
  $locality     = undef,
  $aliases      = [],
  $email        = undef,
  $days         = '365',
  $password     = undef,
  $force        = false,
) {

  include keymaster::params

  validate_re($ensure,['^present$','^absent$'])

  case $ensure {
    'present': {
      $file_ensure = 'file'
      $dir_ensure = 'directory'
    }
    default: {
      $file_ensure = 'absent'
      $dir_ensure = 'absent'
    }
  }

  Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

  File {
    owner => $::keymaster::user,
    group => $::keymaster::group,
    mode  => '0640',
  }

  # Define some paths.
  $cert_src_dir  = "${::keymaster::params::keystore_x509}/${name}"
  $cert_cnf_file = "${cert_src_dir}/config.cnf"
  $cert_key_file = "${cert_src_dir}/key.pem"
  $cert_csr_file = "${cert_src_dir}/request.csr"
  $cert_crt_file = "${cert_src_dir}/certificate.crt"


  # Create the x509 store directory
  file{"x509_${name}_dir":
    ensure => $dir_ensure,
    path   => $cert_src_dir,
    mode   => '0755',
  }

  # Create cnf
  file{"x509_${name}_cnf":
    ensure  => $file_ensure,
    path    => $cert_cnf_file,
    content => template('keymaster/config.cnf.erb'),
  }

  if $ensure == 'present' {
    # Create private key
    exec{"x509_${name}_key":
      command => "openssl genrsa -out ${cert_key_file} 2048",
      user    => $::keymaster::user,
      group   => $::keymaster::group,
      creates => $cert_key_file,
      require => File["x509_${name}_cnf"],
      before  => File["x509_${name}_key"],
    }
    # Create certificate signing request
    exec{"x509_${name}_csr":
      command => "openssl req -new -key ${cert_key_file} -out ${cert_csr_file} -config ${cert_cnf_file}",
      user    => $::keymaster::user,
      group   => $::keymaster::group,
      creates => $cert_csr_file,
      require => File["x509_${name}_key"],
      before  => File["x509_${name}_csr"],
    }

    # Create certificate signing request
    exec{"x509_${name}_crt":
      command => "openssl x509 -req -days ${days} -in ${cert_csr_file} -signkey ${cert_key_file} -out ${cert_crt_file}",
      user    => $::keymaster::user,
      group   => $::keymaster::group,
      creates => $cert_crt_file,
      require => File["x509_${name}_csr"],
      before  => File["x509_${name}_crt"],
    }
  }

  file{"x509_${name}_key":
    ensure => $file_ensure,
    path   => $cert_key_file
  }

  file{"x509_${name}_csr":
    ensure => $file_ensure,
    path   => $cert_csr_file
  }

  file{"x509_${name}_crt":
    ensure => $file_ensure,
    path   => $cert_crt_file
  }

}

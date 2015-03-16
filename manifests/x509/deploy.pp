# This deploys a x509 certifiate onto a node
define keymaster::x509::deploy (
  $ensure      = 'present',
  $key_path    = undef,
  $cert_path   = undef,
  $key_file    = undef,
  $cert_file   = undef,
  $type        = undef,
  $owner       = undef,
  $group       = undef,
  $deploy_key  = true,
  $deploy_cert = true
) {

  validate_re($ensure,['^present$','^absent$'])

  if $deploy_key {
    $key_ensure = $ensure
  } else {
    $key_ensure = 'absent'
  }

  if $deploy_cert {
    $cert_ensure = $ensure
  } else {
    $cert_ensure = 'absent'
  }

  if $key_file {
    $real_key_path = "${key_path}/${key_file}"
  }

  if $cert_file {
    $real_cert_path = "${cert_path}/${cert_file}"
  }

  Keymaster::X509::Cert::Deploy <<| tag == $name |>>{
    ensure => $cert_ensure,
    path   => $real_cert_path,
    type   => $type,
    owner  => $owner,
    group  => $group,
  }

  Keymaster::X509::Key::Deploy <<| tag == $name |>>{
    ensure => $key_ensure,
    path   => $real_key_path,
    owner  => $owner,
    group  => $group,
  }

}

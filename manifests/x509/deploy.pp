# This deploys a x509 certifiate onto a node
define keymaster::x509::deploy (
  $ensure      = 'present',
  $key_path    = undef,
  $cert_path   = undef,
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


  Keymaster::X509::Cert::Deploy <<| tag == $name |>>{
    ensure => $cert_ensure,
    path   => $cert_path,
    type   => $type,
    owner  => $owner,
    group  => $group,
  }

  Keymaster::X509::Key::Deploy <<| tag == $name |>>{
    ensure => $key_ensure,
    path   => $key_path,
    owner  => $owner,
    group  => $group,
  }

}

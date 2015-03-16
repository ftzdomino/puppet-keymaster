# This deploys a host key onto a node
define keymaster::host_key::redeploy (
  $ensure = 'present'
) {

  validate_re($ensure,['^present$','^absent$'])

  Keymaster::Host_key::Key::Deploy <<| tag == $name |>>{
    ensure => $ensure,
  }

}

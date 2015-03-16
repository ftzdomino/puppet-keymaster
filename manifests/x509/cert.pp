# creates and deploys x509 certs
define keymaster::x509::cert (
  $country,
  $organization,
  $commonname,
  $ensure      = 'present',
  $selfsign    = true,
  $type        = 'crt',
  $state       = undef,
  $locality    = undef,
  $aliases     = [],
  $email       = undef,
  $days        = '365',
  $password    = undef,
  $cert_path   = undef,
  $key_path    = undef,
  $owner       = undef,
  $group       = undef,
  $force       = false,
  $deploy_cert = true,
  $deploy_key  = true,
) {

  validate_re($ensure,['^present$','^absent$'])
  validate_re($type,['pem','cer','crt','der','p12'])
  validate_re(
    $name,
    '^[A-Za-z0-9][A-Za-z0-9_.-]+$',
    "${name} must start with a letter or digit, and may only contain the characters A-Za-z0-9_.-"
  )

  # generate exported resources for the keymaster to realize
  @@keymaster::x509::cert::generate { $name:
    ensure       => $ensure,
    country      => $country,
    organisation => $organization,
    commonname   => $commonname,
    state        => $state,
    locality     => $locality,
    aliases      => $aliases ,
    email        => $email,
    days         => $days,
    password     => $password,
    force        => $force,
    tag          => $name,
  }

  # generate exported resources for the ssh client host to realize
  # @@keymaster::x509::cert::deploy { $name:
  #   tag    => $name,
  # }

  # @@keymaster::x509::key::deploy { $name:
  #   tag    => $name,
  # }

  # if $deploy_cert or $deploy_key {
  #   keymaster::x509::deploy { $name:
  #     ensure      => $ensure,
  #     cert_path   => $cert_path,
  #     key_path    => $key_path,
  #     type        => $type,
  #     owner       => $owner,
  #     group       => $group,
  #     deploy_cert => $deploy_cert,
  #     deploy_key  => $deploy_key,
  #   }
  # }

}

# This private resource deploys a key pair into a user's account
# This resource should not be called in a manafiest and should only be
# used by keymaster::openssh::key
define keymaster::openssh::key::deploy (
  $user,
  $filename,
  $ensure = 'present',
) {

  if ! defined(User[$user]) {
    fail("The user '${user}' has not been defined in Puppet")
  }

  # get homedir and primary group of $user
  $home  = getparam(User[$user],'home')
  $group = getparam(User[$user],'gid')

  $clean_name = regsubst($name, '@', '_at_')
  # filename of private key on the keymaster (source)
  $key_src_file = "${::keymaster::keystore_openssh}/${clean_name}/key"

  # filename of private key on the ssh client host (target)
  $key_tgt_file = "${home}/.ssh/${filename}"

  # contents of public key on the keymaster
  $key_src_content_pub = file("${key_src_file}.pub", '/dev/null')



  # If 'absent', revoke the client keys
  if $ensure == 'absent' {
    file {[ $key_tgt_file, "${key_tgt_file}.pub" ]: ensure  => 'absent' }

  # test for homedir and primary group
  } elsif ! $home {
    fail( "Can't determine home directory of user ${user}" )

  # If syntax of pubkey checks out, install keypair on client
  } elsif ( $key_src_content_pub =~ /^(ssh-...) ([^ ]+)/ ) {
    $keytype = $1
    $modulus = $2

    # Mangling all the non-true values for group
    # the choices were to force undefined or use $name
    # $name might be unpredictible... so undef
    if $group {
      $real_group = $group
    } else {
      warning("Can't determine primary group of user ${user}")
      $real_group = undef
    }

    # QUESTION: what about the homedir?  should we create that if 
    # not defined also? I think not.
    #
    # create client user's .ssh file if defined already
    if ! defined(File[ "${home}/.ssh" ]) {
      file { "${home}/.ssh":
        ensure => 'directory',
        owner  => $user,
        group  => $real_group,
        mode   => '0700',
      }
    }

    file { $key_tgt_file:
      ensure  => 'file',
      content => file($key_src_file, '/dev/null'),
      owner   => $user,
      group   => $real_group,
      mode    => '0600',
      require => File["${home}/.ssh"],
    }

    file { "${key_tgt_file}.pub":
      ensure  => 'file',
      content => "${keytype} ${modulus} ${name}\n",
      owner   => $user,
      group   => $real_group,
      mode    => '0644',
      require => File["${home}/.ssh"],
    }

  } else {
    warning("Private key file ${key_src_file} for key ${name} not found on keymaster.")
  }

}

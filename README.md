# Keymaster

The Keymaster Puppet module is intended to manage the deployment and redeployment of keys, certificate, and other security tokens across Puppet nodes, services, applications, and users.

Keymaster will generate self-signed keys and deploy them, or can deploy keys that have been pre-generated and seeded into it's keystore.

Initially Keymaster will handle SSH keys and certificates for users and host SSH keys and certificates for nodes. The intent is to be sure that these keys are well known to the Puppet manifest and can be used and deployed through the Puppet infrastructure.

It is the intention that using Keymaster means that the encrypted part of a key or certificate not be stored in a Puppet manifest or Hiera data store.

# References

* [ssh::auth](http://projects.puppetlabs.com/projects/1/wiki/Module_Ssh_Auth_Patterns) This module is recommended for installing and configuring `ssh` and the `sshd` service. This module has been used to test the Keymaster module.
* [saz-ssh](https://forge.puppetlabs.com/saz/ssh)
* [ashleygould puppet-sshauth](https://github.com/ashleygould/puppet-sshauth)
* [Aethylred puppet-sshauth](https://github.com/aethylred/puppet-sshauth)
* [vurbia pppet-sshauth](https://github.com/vurbia/puppet-sshauth)

# Attribution

## puppet-blank

This module is derived from the [puppet-blank](https://github.com/Aethylred/puppet-blank) module by Aaron Hicks (aethylred@gmail.com)

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/
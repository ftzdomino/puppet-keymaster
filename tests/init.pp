# This file is part of the keymaster Puppet module.
include keymaster
user{'tester': }

keymaster::openssh::key{'testerkey': }

keymaster::openssh::deploy_pair{'testerkey':
  user => 'tester',
}

keymaster::openssh::authorize{'testerkey':
  user => 'tester',
}